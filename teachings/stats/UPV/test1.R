library(plotly)
library(dplyr)

fig <- plot_ly()

finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]
labels <- paste0(" ", rownames(finePots), ". ", finePots$Place)
finePots <- finePots[ , c("Place", "OxfordPct", "NewForestPct")]
ws.melt <- melt(finePots)
ct <- 0
for(a.place in unique(ws.melt$Place)){
  # a.place <- "Dorchester (Dorset)"
  df <- ws.melt[ws.melt$Place == a.place, ]
  labels <- paste0(rownames(finePots[finePots$Place == a.place, ]), ". ", a.place)
  fig <- fig %>% add_pie(data = df, labels = ~variable, values = ~value,
                         name = labels, domain = list(row = ct, column = 0))
  ct <- ct + 1
}
fig %>% layout(title = "Ratios", showlegend = F,
               grid=list(rows=ct, columns=1),
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
ct

fig <- fig %>% add_pie(data = count(diamonds, color), labels = ~color, values = ~n,
                       name = "Color", domain = list(row = 0, column = 1))
fig <- fig %>% add_pie(data = count(diamonds, clarity), labels = ~clarity, values = ~n,
                       name = "Clarity", domain = list(row = 1, column = 0))
fig <- fig %>% add_pie(data = count(diamonds, cut), labels = ~cut, values = ~n,
                       name = "Clarity", domain = list(row = 1, column = 1))
fig <- fig %>% layout(title = "Pie Charts with Subplots", showlegend = F,
                      grid=list(rows=2, columns=2),
                      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

fig





library(plotly)
library(archdata)
library(reshape2)

data(OxfordPots)

finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]
labels <- paste0(" ", rownames(finePots), ". ", finePots$Place)
finePots <- finePots[ , c("Place", "OxfordPct", "NewForestPct")]
ws.melt <- melt(finePots)
ggplot(ws.melt, aes(x = "", y = value, fill = variable)) + 
  facet_grid(Place ~ .) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start=0) + 
  theme_void()



###############

library(leaflet.minicharts)

Place.coords.path <- "C:/Rprojects/thomashuet/teachings/stats/_stats/dim2/oxfordpots_data.xlsx"
Place.coords <- openxlsx::read.xlsx(Place.coords.path, 1)
Place.coords <- Place.coords[ , c("Place", "lon", "lat")]
Place.coords[, c("lon", "lat")] <- sapply(Place.coords[, c("lon", "lat")], as.numeric)
df.both <- merge(finePots, Place.coords, by = "Place")

leaflet(df.both) %>%
  addProviderTiles(providers$"OpenStreetMap", group = "OSM") %>%
  addMinicharts(
    lng = ~lon, 
    lat = ~lat,
    type = "pie",
    chartdata = df.both[, c("OxfordPct", "NewForestPct")]
  )
  add_text(x = ~lon, y = ~lat, text = ~Place, textposition = 'middle right')

leaflet(data = df.both) %>%
  # add_text(x = ~lon, y = ~lat, text = ~Place, textposition = 'middle right') %>%
  addMinicharts(
    # labelText = df.both$Place,
    lng = ~lon, 
    lat = ~lat,
    type = "pie",
    chartdata = df.both[, c("OxfordPct", "NewForestPct")]
  )

leaflet(data = df.both) %>%
  addMinicharts(
    lng = ~lon, 
    lat = ~lat,
    type = "pie",
    chartdata = df.both[, c("OxfordPct", "NewForestPct")]
  )

View(finePots)

leaflet() %>%
  addProviderTiles(providers$"OpenStreetMap", group = "OSM") %>%
  # addProviderTiles(providers$"Esri.WorldImagery", group = "Ortho") %>%
  addGraticule(interval = 1) %>%
  addMinicharts(
    lng = df.both$lon, 
    lat = df.both$lat,
    type = "pie",
    chartdata = df.both[, c("OxfordPct", "NewForestPct")]) %>%
  addLabelOnlyMarkers(data = df.both,
                      lng = ~lon, 
                      lat = ~lat,
                      label =  ~Place, 
                      labelOptions = labelOptions(noHide = T, 
                                                  direction = 'top',
                                                  textOnly = T,
                                                  style = list(
                                                    "color" = "black", 
                                                    # "font-family" = "serif",
                                                    "font-style" = "bold",
                                                    # "box-shadow" = "1px 1px rgba(0,0,0,0.25)",
                                                    "font-size" = "12px"
                                                    # "border-color" = "rgba(0,0,0,0.5)",
                                                    # "padding" = "2px" 
                                                  )))


  add_text(x = ~lon, y = ~lat, text = ~Place, textposition = 'middle right') 

