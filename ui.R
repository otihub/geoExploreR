
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#



shinyUI(
  bootstrapPage(tags$head(
   # includeScript("google-analytics.js")
    ),
                
  dashboardPage(#tags$head(includeScript()),
    title="Diffa Perception Survey",
                skin = 'green',
                
                
                dashboardHeader(title = HTML(paste(icon('globe'),'Diffa Perception Survey'))
                                
                                # a(icon('github fa-2x'),href='https://github.com/davesteps/homebrewR'),
                                # a(icon('twitter fa-2x'),href='https://twitter.com/davesteps')
                ),
                
                dashboardSidebar(
                  
                  selectInput('dataset',label = 'Dataset',
                              choices = c('Round 1')),
                  #                     selectInput('xvar',label='x Var',choices = names(meuse@data),selected =  names(meuse@data)[1]),
                  #                     selectInput('yvar',label='y Var',choices = names(meuse@data),selected = names(meuse@data)[2]),
                  #                     selectInput('color',label='Color Var',choices = names(meuse@data),selected =  names(meuse@data)[1]),
                  #                     
                  uiOutput('xvar'),
                  uiOutput('yvar'),
                  uiOutput('cvar'),
                  
                  selectInput("pal", "Color palette",selected = 'BrBG',
                              rownames(subset(brewer.pal.info, category %in% c("seq", "div")))),
                  uiOutput("ui"),
                  
                  absolutePanel(
                    bottom = 10,
                    left = 10,
                    draggable = F,
                    width='100%',
                    height='auto' ,
                 #   p(a(icon('github fa-2x'),href='https://github.com/davesteps/geoExploreR',target='_blank')),
                   HTML("<div style='float:center'>")
                    
                    # a(icon('github fa-2x'),href='https://github.com/davesteps/geoExploreR',target='_blank')
                    # a(icon('twitter fa-2x'),href='https://twitter.com/davesteps',target='_blank')
                  )                  
                  
                ),
                dashboardBody(
                  
                  # tabItems(
                  # tabItem("dash",
                  
                  #                             box(width=2,status = 'success',
                  #                                 selectInput('dataset',label = 'Dataset',
                  #                                             choices = c('Quakes','Meuse','Jura','Fulmar')),
                  #                                 #                     selectInput('xvar',label='x Var',choices = names(meuse@data),selected =  names(meuse@data)[1]),
                  #                                 #                     selectInput('yvar',label='y Var',choices = names(meuse@data),selected = names(meuse@data)[2]),
                  #                                 #                     selectInput('color',label='Color Var',choices = names(meuse@data),selected =  names(meuse@data)[1]),
                  #                                 #                     
                  #                                 uiOutput('xvar'),
                  #                                 uiOutput('yvar'),
                  #                                 uiOutput('cvar'),
                  #                                 
                  #                                 selectInput("pal", "Color palette",selected = 'BrBG',
                  #                                             rownames(subset(brewer.pal.info, category %in% c("seq", "div")))),
                  #                                 uiOutput("ui")
                  # 
                  #                                 
                  #                             ),
                  #                             
                  box(width = 6,status = 'warning',
                      div(style = "height: 400px;",
                          ggvisOutput("p")),
                      paste("Distribution"),
                      fluidRow(
                        column(width=6,
                               div(style = "height: 175px;",
                                   ggvisOutput("p2"))),
                        column(width=6,
                               div(style = "height: 175px;",
                                   ggvisOutput("p3")))
                      )
                      
                  ),                  
                  
                  box(width = 6,status = 'warning',
                      leafletOutput("map",height = 600)
                  )
                  
                  
                  
                  
                )
  )
)
)