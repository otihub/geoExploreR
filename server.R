#####################################
##
## TODO:
##  - axis names
##  - open popup on plot when mouse hover on map
##  - factor varialbes in color
##  - scale transforms
##  - choose plot type
##  - map point info overlay
##
######################################
# 


function(input, output,session) {
  
  output$map <- renderLeaflet({
    print('render map')
    leaflet() %>% #addTiles() %>% 
      #addProviderTiles("Esri.OceanBasemap", group = "Esri.OceanBasemap") %>%
      addProviderTiles("CartoDB.Positron", group = "Carto Positron") %>%
      addProviderTiles("OpenStreetMap.HOT", group = "Humanitarian OSM") %>%
      #addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreetmap") %>%
      addProviderTiles("Esri.WorldImagery", group = "Esri WorldImagery") %>%
      addLayersControl(baseGroups = c('Carto Positron',"Humanitarian OSM",  'Esri WorldImagery'),
                       options = layersControlOptions(collapsed = TRUE, autoZIndex = F))
  })
  
  
  
  df <- datasets[['Round 1']]
  makeReactiveBinding('df')
  
  observeEvent(input$dataset,{
    print('dataset')
    leafletProxy('map')%>%clearShapes()
    df <<- datasets[[input$dataset]]  
    i.active <<- NULL
    
  })
  
  
  coords <- reactive({
    print('coords')
    
    crds <- data.frame(coordinates(df))
    leafletProxy('map')%>%fitBounds(lng1=min(crds[,1]),lng2=max(crds[,1]),
                                    lat1=min(crds[,2]),lat2=max(crds[,2]))
    crds
    
  })
  
  
  output$xvar <- renderUI(selectInput('xvar',label='x Axis',choices = columns, selected =  columns[1]))
  output$yvar <- renderUI(selectInput('yvar',label='y Axis',choices = columns, selected =  columns[2]))
  output$cvar <- renderUI(selectInput('color',label='Color/Map',choices = columns, selected =  columns[1]))
  #output$vvar <- renderUI(selectInput('vvar',label='Village',choices = columns, selected =  columns[1]))
  
  xvar_ <- ''
  xVar <- reactive({
    print('xVar')
    if(is.null(input$xvar)) return(names(df)[1])
    xvar_ <<- input$xvar
    input$xvar})
  yVar <- reactive({
    if(is.null(input$yvar)) return(names(df)[2])
    input$yvar})
  colorVar <- reactive({
    print('colVar')
    if(is.null(input$color)) return(names(df)[1])
    input$color})
  
  
  
  ggvisdf <- reactive({
    print('ggvesdf1')
    df1 <- isolate(df@data)
    gdf <- df1[, c(xVar(), yVar(), "Village")]
    names(gdf) <- c("x", "y", "Village")
    gdf
  })  
  
  
  colorData <- reactive({
    print(names(input))
    print('colData')
    df1 <- isolate(df@data)
    df1[,colorVar()]})
  colorpal <- reactive(colorNumeric(input$pal, colorData()))
  pal <- reactive({colorpal()(colorData())})
  
  observe({
    
    print('update map size/opa/color')
    x <- coords()[,1]
    y <- coords()[,2]
    leafletProxy('map')%>%
      addCircleMarkers(lng=x,fillColor = pal(),
                       lat=y,
                       stroke = F,
                       layerId = as.character(1:length(x)),
                       radius = input$size/10,
                       fillOpacity = 1
      )
    
  })
  
  
  
  observe({
    print('legend')
    leafletProxy("map")%>%
      clearControls() %>% 
      addLegend(opacity = 0.99,position = "bottomright",title = colorVar(), 
                labFormat = labelFormat(suffix = '%', between = '%-', transform = function(x) 100 * x),
                pal = colorpal(), values = rev(colorData()))
    
  })
  
  
  mapData <- reactive({
    print('mapdata')
    
    mb <- input$map_bounds
    
    if(is.null(mb))
      return(1)#as.vector(rep(1,nrow(coords()))))
    if(nrow(coords())!=nrow((ggvisdf())))
      return(1)
    
    as.numeric(coords()[,1]>mb$west&coords()[,1]<mb$east&
                 coords()[,2]>mb$south&coords()[,2]<mb$north)+0.1
    
  })
  
  
  tooltip <- function(x) {
    ggvisHover <<- x
    if(is.null(x)) return(NULL)
    tt<<-paste0(c("Village", xVar(),yVar()),  ": ",c(format(x$Village), format(percent(x[1:2]))), collapse = "<br/>")
    leafletProxy('map') %>%addControl(tt,layerId = 'tt',position = 'bottomleft')
    tt
    
  }
  
  
  
  
  
  ggvisHover <- NULL
  makeReactiveBinding('ggvisHover')
  i.active <- NULL
  makeReactiveBinding('i.active')
  
  
  observeEvent(ggvisHover,{
    h <- ggvisHover[1:2]
    i.active <<- ggvisdf()[,'x']==h[[1]]&ggvisdf()[,'y']==h[[2]]
  })
  
  observeEvent(input$map_marker_mouseover,{
    id <- as.numeric(input$map_marker_mouseover$id)
    if(!is.na(id)){
      i.active <<- id
    }
  })
  
  observeEvent(i.active,{
    leafletProxy('map') %>%
      # removeMarker('hover') %>%
      addCircleMarkers(lat=coords()[i.active,2],opacity = 1,
                       fillOpacity = 0,
                       radius = (input$size/5),
                       lng=coords()[i.active,1],
                       layerId = 'hover',weight = 6,
                       color = 'red') 
  })
  
  mouseOver <- reactive({
    
    p <- ggvisdf()[i.active,c('x','y', "Village")]
    if(class(i.active)=='numeric')
    {tooltip(p)}
    p
  })
  
  
  
  
  ggvisdf %>% 
    ggvis(~x,~y) %>%
    set_options(width = "auto", height = "auto", resizable=FALSE) %>%    
    add_axis("x", format = '%')  %>% 
    add_axis("y", format = '%', title_offset = 50)  %>% 
    layer_points(size := input_slider(1, 100, value = 30,id='size',label = 'Size'),
                 opacity := mapData,
                 fill := pal) %>% 
    add_tooltip(tooltip, "hover") %>%
    layer_points(data =mouseOver,stroke:='red',size := 150,fillOpacity=0,strokeWidth:=5) %>%
    bind_shiny("p",'ui')
  
  ggvisdf %>% 
    ggvis(~x) %>%
    set_options(width = "auto", height = "auto", resizable=FALSE) %>%    
    add_axis("y", title = '')  %>% 
    add_axis("x",format = '%', ticks = 5, properties = axis_props(labels = list(angle = 45, align = "left", fontSize = 7))) %>%
    layer_densities(fill := '#000054') %>% 
    layer_points(data =mouseOver,stroke:='red',size := 10) %>%
    bind_shiny("p2")
  
  ggvisdf %>% 
    ggvis(~y) %>%
    layer_densities(fill := '#000054') %>% 
    set_options(width = "auto", height = "auto", resizable=FALSE) %>%    
    add_axis("y", title = "")  %>% 
    add_axis("x",format = '%', ticks = 5, properties = axis_props(labels = list(angle = 45, align = "left", fontSize = 7))) %>%
    layer_points(data =mouseOver,stroke:='red',size := 10) %>%
    bind_shiny("p3")
  
  
}



