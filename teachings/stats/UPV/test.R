
library(plotly)
library(archdata)

data(OxfordPots)

finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]
labels <- paste0(" ", rownames(finePots), ". ", finePots$Place)

t <- list(
  family = "sans serif",
  size = 14,
  color = "blue")

image <- list(  
  list(  
    # sources of images
    source =  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Iris_setosa_var._setosa_%282595031014%29.jpg/360px-Iris_setosa_var._setosa_%282595031014%29.jpg",  
    row=1, 
    col=1, 
    source=1, 
    xref="x domain", 
    yref="y domain", 
    x=1, 
    y=1, 
    xanchor="right", 
    yanchor="top", 
    sizex=0.2, 
    sizey=0.2 
  )
)


plot_ly(finePots, x = ~OxfordPct, y = ~NewForestPct, text = labels) %>% 
  # add_trace(mode = "markers", text = labels, hoverinfo = 'text') %>%
  # add_annotations(#text = rownames(data),
  #   xref = "x",
  #   yref = "y",
  #   showarrow = TRUE,
  #   arrowhead = 4,
  #   arrowsize = .5,
  #   ax = 10,
  #   ay = -20) %>%
  add_markers() %>%
  add_text(textfont = t, textposition = 'middle right') %>%
  layout(title = paste0('Ratio of Oxford pottery/New Forest pottery for ', nrow(finePots),' Late Roman sites'),
         xaxis = list(title = "% Oxford pottery"), 
         yaxis = list(title = "% New Forest pottery"),
         images = image)


data(iris)
plot_ly(data = iris, 
        x = ~Sepal.Length, 
        y = ~Petal.Length, 
        mode = "markers", 
        color = ~Species) %>%
  layout(legend = list(orientation = "h",   # show entries horizontally
                       xanchor = "center",  # use center of legend as anchor
                       x = 0.5))             # put legend in center of x-axis

#





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
