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
