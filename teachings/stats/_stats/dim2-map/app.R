# Teaching app
# data with 2 dimensions


library(shiny)
library(leaflet)
# library(plotly)
library(archdata)

data(OxfordPots)

Oxford.water <- subset(OxfordPots, WaterTrans == 1)
Oxford.lm.water <- lm(log(OxfordPct)~OxfordDst, Oxford.water)
lm.water <- lm(OxfordPct ~ OxfordDst, data = Oxford.water)
# lm.water.R2 <- round(summary(lm.water)$r.squared, 2)
r2.water <- round(summary(lm.water)$r.squared, 2)
Oxford.water$predicted <- predict(lm.water)   # Save the predicted values
Oxford.water$residuals <- residuals(lm.water) # Save the residual values
water.values <- paste0("<b>", Oxford.water$Place, "</b><br>", 
                       "Observed: ", Oxford.water$OxfordPct)
water.residuals <- paste0("<b>", Oxford.water$Place, "</b><br>",
                          "Observed: ", round(Oxford.water$predicted, 2))

# no water
Oxford.nowater <- subset(OxfordPots, WaterTrans == 0)
Oxford.lm.nowater <- lm(log(OxfordPct)~OxfordDst, Oxford.nowater)
lm.nowater <- lm(OxfordPct ~ OxfordDst, data = Oxford.nowater)
r2.nowater <- round(summary(lm.nowater)$r.squared, 2)
# lm.nowater.R2 <- round(summary(lm.nowater)$r.squared, 2)
Oxford.nowater$predicted <- predict(lm.nowater)   # Save the predicted values
Oxford.nowater$residuals <- residuals(lm.nowater) # Save the residual values
nowater.values <- paste0("<b>", Oxford.nowater$Place, "</b><br>", 
                         "Observed: ", Oxford.nowater$OxfordPct)
nowater.residuals <- paste0("<b>", Oxford.nowater$Place, "</b><br>",
                            "Observed: ", round(Oxford.nowater$predicted, 2))


Place.coords.path <- "C:/Rprojects/thomashuet/teachings/stats/_stats/dim2/oxfordpots_data.xlsx"
Place.coords <- openxlsx::read.xlsx(Place.coords.path, 1)
Place.coords <- Place.coords[ , c("Place", "lon", "lat")]
Place.coords[, c("lon", "lat")] <- sapply(Place.coords[, c("lon", "lat")], as.numeric)

df.nowater <- merge(Oxford.nowater, Place.coords, by = "Place")
df.water <- merge(Oxford.water, Place.coords, by = "Place")

# leaflet(Place.coords) %>%
#   addProviderTiles(providers$"OpenStreetMap", group = "OSM") %>%
#   addProviderTiles(providers$"Esri.WorldImagery", group = "Ortho") %>%
#   addCircleMarkers(data = df.water,
#                    lng = ~lon,
#                    lat = ~lat,
#                    weight = 1,
#                    radius = 4,
#                    popup = ~Place,
#                    color = "black",
#                    fillOpacity = 1,
#                    opacity = 1) %>%
#   addCircleMarkers(data = df.nowater,
#                    lng = ~lon,
#                    lat = ~lat,
#                    weight = 2,
#                    radius = 4,
#                    popup = ~Place,
#                    color = "black",
#                    fillOpacity = 0,
#                    stroke = TRUE,
#                    opacity = 1) %>%
#   addLayersControl(
#     baseGroups = c("OSM", "Ortho"),
#     position = "topright") %>%
#   addScaleBar(position = "bottomright")


ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("Distribution of Late Romano-British Oxford Pottery"),
  fluidRow(column(3, radioButtons("residuals", "show residuals",
                                  choices = c("Yes", "No"), selected = "No"))
  ),
  leafletOutput("mymap", width = 700, height = 700),
  HTML("Sources:<br>
  Hodder, I. 1974. A Regression Analysis of Some Trade and Marketing Patterns. World Archaeology 6: 172-189.<br>
  Hodder, I. and C. Orton. 1976. Spatial Analysis in Archaeology, pp 117-119.
     ")
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    map <- leaflet(Place.coords) %>%
      addProviderTiles(providers$"OpenStreetMap", group = "OSM") %>%
      addProviderTiles(providers$"Esri.WorldImagery", group = "Ortho") 
    if("No" %in% input$residuals){
      map <- map %>%
        addCircleMarkers(data = df.water,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 1,
                         radius = 4,
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 1,
                         opacity = 1) %>%
        addCircleMarkers(data = df.nowater,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 2,
                         radius = 4,
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 0,
                         stroke = TRUE,
                         opacity = 1) 
    }
    if("Yes" %in% input$residuals){
      map <- map %>%
        addCircleMarkers(data = df.water,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 1,
                         radius = ~abs(residuals),
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 1,
                         opacity = 1) %>%
        addCircleMarkers(data = df.nowater,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 2,
                         radius = ~abs(residuals),
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 0,
                         stroke = TRUE,
                         opacity = 1) 
    }
    map %>%
      addLayersControl(
        baseGroups = c("OSM", "Ortho"),
        position = "topright") %>%
      addScaleBar(position = "bottomright")
  })
}

shinyApp(ui, server)


