library(shiny)
# library(sp)
library(spatstat)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("geom", 
                  label = "Geometry type",
                  choices = c("Point", "Line", "Polygon"),
                  selected = "Point"),
      checkboxGroupInput("stat",
                         label = "Display",
                         choices = c("Centroid",
                                     "Convexhull",
                                     "Bounding box",
                                     "Bounding circle"))
    ),
    mainPanel(
      fluidRow(plotOutput(outputId = "spatPlot")
      )
    )
  )
)

server <- function(input, output) {
  x1 <- seq(1:10)
  w <- as.owin(c(min(x1), max(x1),
                 min(x1), max(x1)))
  plot(w, lwd=3, main = "")
  pts <- runifpoint(5, win = w)
  output$spatPlot <- renderPlot({
    if (input$geom == "Point") {
      plot(pts)
      if ("Bounding circle" %in% input$stat) {
        mbc <- boundingcircle(pts)
        plot(mbc, add = TRUE)
      }
      if ("Bounding box" %in% input$stat) {
        mbr <- boundingbox(pts)
        plot(mbr, add = TRUE)
      }
      if ("Convexhull" %in% input$stat) {
        ch <- convexhull(pts)
        # plot(pts)
        plot(ch, add = TRUE)
      }
      if ("Centroid" %in% input$stat) {
        ctr <- centroid.owin(pts, as.ppp = FALSE)
        # plot(pts)
        points(mean(pts$x), mean(pts$y), pch = 16)
      }
    }
    if (input$geom == "Line") {
      plot(pts)
      segments(x0 = pts$x[-length(pts$x)], 
               y0 = pts$y[-length(pts$y)], 
               x1 = pts$x[-1], 
               y1 = pts$y[-1],
               col = "darkgreen")
      if ("Bounding circle" %in% input$stat) {
        mbc <- boundingcircle(pts)
        plot(mbc, add = TRUE)
      }
      if ("Bounding box" %in% input$stat) {
        mbr <- boundingbox(pts)
        plot(mbr, add = TRUE)
      }
      if ("Convexhull" %in% input$stat) {
        ch <- convexhull(pts)
        plot(ch, add = TRUE)
      }
      if ("Centroid" %in% input$stat) {
        d <-data.frame(x0 = pts$x[-length(pts$x)], 
                       y0 = pts$y[-length(pts$y)], 
                       x1 = pts$x[-1], 
                       y1 = pts$y[-1])
        d$xmean <- rowMeans(cbind(d$x0, d$x1))
        d$ymean <- rowMeans(cbind(d$y0, d$y1))
        points(d$xmean, 
               d$ymean,
               pch = 16,
               col = "darkgreen")
      }
    }
  })
}


shinyApp(ui, server)
