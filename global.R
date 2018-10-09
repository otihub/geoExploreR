require(shiny)
require(shinydashboard)
require(shinyjs)
require(leaflet)
require(ggvis)
require(dplyr)
library(RColorBrewer)
require(raster)
require(gstat)
require(rgdal)
require(Cairo)
library(formattable)


#data(meuse)
#coordinates(meuse) = ~x+y
#proj4string(meuse) <- CRS("+init=epsg:28992")
#meuse <- spTransform(meuse, CRSobj = CRS("+proj=longlat +datum=WGS84 +no_defs"))

#data("quakes")
#names(quakes)[1:2] <- c('y','x')
#coordinates(quakes) <- ~x+y

#data('jura')
#jura <-jura.val[,c(3,4,7:13,5,6)]
#names(jura)[1:2] <- c('x','y')
#coordinates(jura) <- ~x+y

#Test$Date<-as.Date(Test$Date)
difr1<-read.csv(file='diffa_r1.csv',sep = ',')
#test4<-test4[2:5]
#test4$Date<-as.yearmon(test4$Date)
#test4$Date<-as.Date(test4$Date)
names(difr1)[18:19] <- c('y','x')
difr1<-subset(difr1, y>0)
difr1[is.na(difr1)]<-0

coordinates(difr1) <- ~x+y

#data(fulmar)
#coordinates(fulmar) <- ~x+y
#proj4string(fulmar) <- CRS("+init=epsg:32631")
#fulmar <- spTransform(fulmar, CRSobj = CRS("+proj=longlat +datum=WGS84 +no_defs"))

datasets <- list(
#  'Meuse'=meuse,
#  'Quakes'=quakes,
#  'Jura'=jura,
#  'Fulmar'=fulmar,
  'Round 1'=difr1
)

baselayers <- list(
#  'Meuse'='DarkMatter (CartoDB)',
#  'Quakes'="Esri.OceanBasemap",
#  'Jura'='OpenStreetmap',
#  'Fulmar'='OpenStreetmap',
 'Round 1'='Carto Positron'
)

columns<- list(
  "Most people in this group can be trusted?[People in your neighborhood]"="Trust.Neighbors",
  "Most people in this group can be trusted?[Traditional leaders]"="Trust.Trad.Leaders",
  "Most people in this group can be trusted?[Religious leaders]"="Trust.Rel.Leaders",
  "Most people in this group can be trusted?[Local political leaders]"="Trust.Local.Leaders",     
  "Most people in this group can be trusted?[National political leaders]"="Trust.Natl.Leaders",
  "% with total or some confidence[Local government leaders]"="Confidence.Loc.Govt",
  "% with total or some confidence[Police/Law enforcement]"="Confidence.Police",
  "It is always or sometimes justified to use violence when someone insults my religion"="Violence.Justified.Religion",      
  "It is always or sometimes justified to use violence when someone personally insults me"="Violence.Justified.Personal",
  "It is always or sometimes justified to use violence when someone insults my political party"="Violence.Justified.Political",
  "Influence of Boko Haram in your community [% answering positive or very positive]"="Boko.Positive.Influence",
  "Former Boko Haram/IS WA members should be allowed to return if they only did low-level jobs"="Returnif.Low.Level",
  "Former Boko Haram/IS WA members should be allowed to return if asked for forgiveness from the community"="Returnif.Ask.Forgiveness",   
  "Former Boko Haram/IS WA members should be allowed to return if they have been released from prison or completed the legal
process"="Return.with.Legal.Process"  
  
)




