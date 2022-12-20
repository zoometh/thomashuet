# Teaching app
# data with 2 dimensions

library(plotly)
library(archdata)
library(leaflet)

data(OxfordPots)

Place.coords.path <- "C:/Rprojects/thomashuet/teachings/stats/_stats/dim2/oxfordpots_data.xlsx"
Place.coords <- openxlsx::read.xlsx(Place.coords.path, 1)
Place.coords <- Place.coords[ , c("Place", "lon", "lat")]
Place.coords[, c("lon", "lat")] <- sapply(Place.coords[, c("lon", "lat")], as.numeric)
leaflet(Place.coords) %>%
  addProviderTiles(providers$"Esri.WorldImagery", group = "Ortho") %>%
  addProviderTiles(providers$"OpenStreetMap", group = "OSM") %>%
  addCircleMarkers(
    lng = ~lon,
    lat = ~lat,
    weight = 1,
    radius = 5,
    popup = ~Place,
    color = "red",
    fillOpacity = 1,
    opacity = 1) %>%
  addLayersControl(
    baseGroups = c("Ortho", "OSM"),
    position = "topright") %>%
  addScaleBar(position = "bottomright")
