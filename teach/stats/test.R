




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

########################## other #############################################

library('plotly')
library('RCurl')

GHraw.z <- "https://github.com/charlottesirot/elementR/blob/master/inst/www/2.png?raw=true"

NewForP <- "C:/Rprojects/thomashuet/teachings/stats/UPV/images/art-pottery-newforest.jpg"
NewForP.txt <- RCurl::base64Encode(readBin(NewForP, "raw", file.info(OxfordP)[1, "size"]), "txt")
plot_ly(x = c(1, 2, 3), y = c(1, 2, 3), type = 'scatter', mode = 'markers') %>%
  layout(
    images = list(
      list(
        # source =  paste('data:image/png;base64', txt, sep=','),
        source =  paste('data:image/png;base64', NewForP.txt, sep=','),
        xref = "x",
        yref = "y",
        x = 1,
        y = 3,
        sizex = 2,
        sizey = 2,
        sizing = "stretch",
        opacity = 0.4,
        layer = "below"
      )
    )
  )



library(rgdal)
library(raster)
library(rworldmap)
library(graticule)

data(countriesLow)

# plot(pmap)
# op <- par(xpd = NA)
# llgridlines(pmap)


llproj <- projection(countriesLow)

map <- subset(countriesLow, SOVEREIGNT == "United Kindom")

## VicGrid
prj <- "+proj=lcc +lat_1=-36 +lat_2=-38 +lat_0=-37 +lon_0=145 +x_0=2500000 +y_0=2500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

pmap <- spTransform(map, CRS(prj))
#> Warning in showSRID(uprojargs, format = "PROJ", multiline = "NO", prefer_proj
#> = prefer_proj): Discarded datum Unknown based on GRS80 ellipsoid in Proj4
#> definition
#> Warning in spTransform(xSP, CRSobj, ...): NULL source CRS comment, falling back
#> to PROJ string
#> Warning in wkt(obj): CRS object has no comment

## specify exactly where we want meridians and parallels
lons <- seq(-2, 2, length = 5)
lats <- seq(45, 48, length = 6)
## optionally, specify the extents of the meridians and parallels
## here we push them out a little on each side
xl <-  range(lons) + c(-0.4, 0.4)
yl <- range(lats) + c(-0.4, 0.4)
## build the lines with our precise locations and ranges
grat <- graticule(lons, lats, proj = prj, xlim = xl, ylim = yl)
#> Warning in showSRID(uprojargs, format = "PROJ", multiline = "NO", prefer_proj
#> = prefer_proj): Discarded datum Unknown based on GRS80 ellipsoid in Proj4
#> definition
## build the labels, here they sit exactly on the western and northern extent
## of our line ranges
labs <- graticule_labels(lons, lats, xline = min(xl), yline = max(yl), proj = prj)
#> Warning in showSRID(uprojargs, format = "PROJ", multiline = "NO", prefer_proj
#> = prefer_proj): Discarded datum Unknown based on GRS80 ellipsoid in Proj4
#> definition
#> 

plot(extent(grat) + c(4, 2) * 1e5, asp = 1, type = "n", axes = FALSE, xlab = "", ylab = "")
plot(grat, add = TRUE, lty = 5, col = rgb(0, 0, 0, 0.8))
plot(pmap, add = TRUE)
text(subset(labs, labs$islon), lab = parse(text = labs$lab[labs$islon]), pos = 3)
text(subset(labs, !labs$islon), lab = parse(text = labs$lab[!labs$islon]), pos = 2)

plot(pmap)


## set up a map extent and plot
op <- par(mar = rep(0, 4))
plot(extent(grat) + c(4, 2) * 1e5, asp = 1, type = "n", axes = FALSE, xlab = "", ylab = "")
plot(grat, add = TRUE, lty = 5, col = rgb(0, 0, 0, 0.8))
plot(pmap, add = TRUE)
text(subset(labs, labs$islon), lab = parse(text = labs$lab[labs$islon]), pos = 3)
text(subset(labs, !labs$islon), lab = parse(text = labs$lab[!labs$islon]), pos = 2)
par(old.par)


