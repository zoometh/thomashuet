library(FactoMineR)
library(Factoshiny)
data(children)
# Correspondance Analysis with Factoshiny:

seriat <- read.csv("https://raw.githubusercontent.com/keltoskytoi/Multivariate_Statistics_Szentloerinc/master/DATA/fibulae.csv", row.name = 1)

res.shiny=CAshiny(seriat)

# Find your app the way you left it (by clicking on the "Quit the app" button)
res.shiny2=CAshiny(res.shiny)

#CAshiny on a result of a CA
data(children)
res.ca <- CA (children, row.sup = 15:18, col.sup = 6:8)
res.shiny=CAshiny(res.ca)

## End(Not run)




######################### kernel 3d ##########################

library(misc3d)
library(MASS)
library(misc3d)
library(rgl)
library(oce)

dfisotops <- read.csv2("https://raw.githubusercontent.com/zoometh/thomashuet/main/teachings/stats/stats/dim3/dfisotops.csv", sep = ";") # GH
dens3d <- misc3d::kde3d(dfisotops[["Pb206_Pb204"]],
                        dfisotops[["Pb207_Pb204"]],
                        dfisotops[["Pb208_Pb204"]], 
                        n = 40,
                        lims = c(
                          range(dfisotops[["Pb206_Pb204"]]),
                          range(dfisotops[["Pb207_Pb204"]]),
                          range(dfisotops[["Pb208_Pb204"]])
                        )
)
# Find the estimated density at each observed point
datadensity <- approx3d(dens3d$x, dens3d$y, dens3d$z,
                        dens3d$d, 
                        dfisotops[["Pb206_Pb204"]],
                        dfisotops[["Pb207_Pb204"]],
                        dfisotops[["Pb208_Pb204"]])
# Find the contours
prob <- .5
levels <- quantile(datadensity, probs = prob, na.rm = TRUE)

# Plot it
colours <- c("gray", "orange")
cuts <- cut(datadensity, c(0, levels, Inf))
for (i in seq_along(levels(cuts))) {
  gp <- as.numeric(cuts) == i
  spheres3d(dfisotops[gp, "Pb206_Pb204"],
            dfisotops[gp, "Pb207_Pb204"],
            dfisotops[gp, "Pb208_Pb204"],
            col = colours[i],
            radius = 0.2)
}
box3d(col = "gray")
contour3d(dens3d$d, level = levels,
          x = dens3d$x, y = dens3d$y, z = dens3d$z, #exp(-12)
          alpha = .1, color = "red", color2 = "gray", add = TRUE)
title3d(xlab = "x", ylab = "y", zlab = "z")

################################ kernel 3d ####################

library(MASS)
library(ks)
library(misc3d)

x <- dfisotops[ , c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")]
H.pi <- Hpi(x, pilot = "samse")
fhat <- kde(x, H = H.pi, compute.cont = TRUE)  
plot(fhat, drawpoints = TRUE)


x <- rnorm(1000)
y <- 2 + x*rnorm(1000,1,.1) + rnorm(1000)
library(MASS)
den3d <- kde2d(x, y)
persp(den3d, box=FALSE)


########################################

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



##########################

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

