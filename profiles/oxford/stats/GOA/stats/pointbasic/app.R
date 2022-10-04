library(shiny)
# library(shinyjs)
# library(sp)
library(spatstat)
# library(shinyfullscreen)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("geom", 
                  label = "Geometry type",
                  choices = c("Point",
                              "Line",
                              "Polygon"),
                  selected = "Point"),
      # sliderInput("nbpts",
      #             label = "Number of points",
      #             min = 3, value = 5, max = 10, step = 1),
      checkboxGroupInput("stat",
                         label = "Display",
                         choices = c("Convexhull",
                                     "Minimum Bounding Rectangle",
                                     "Minimum Bounding Circle",
                                     "Centroid",
                                     "Delaunay",
                                     "Dirichlet"))
      # fullscreen_all(click_id = "test"),
      # actionButton("refresh", "Refresh", icon = icon("refresh"))
      # actionButton("n_poly", icon = icon("refresh"), label = "")
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
  plot(w, lwd = 3, main = "")
  pts <- runifpoint(6, win = w)
  output$spatPlot <- renderPlot({
    # pts <- runifpoint(input$nbpts, win = w)
    # print(input$refresh)
    if (input$geom == "Point") {
      plot(pts, pch = 16)
      if ("Minimum Bounding Circle" %in% input$stat) {
        mbc <- boundingcircle(pts)
        plot(mbc, add = TRUE, border = "blue")
      }
      if ("Minimum Bounding Rectangle" %in% input$stat) {
        mbr <- boundingbox(pts)
        plot(mbr, add = TRUE, border = "red")
      }
      if ("Convexhull" %in% input$stat) {
        ch <- convexhull(pts)
        # plot(pts)
        plot(ch, add = TRUE, border = "darkgrey")
      }
      if ("Centroid" %in% input$stat) {
        ctr <- centroid.owin(pts, as.ppp = FALSE)
        # plot(pts)
        points(mean(pts$x), mean(pts$y))
      }
      if ("Dirichlet" %in% input$stat) {
        # ctr <- centroid.owin(pts, as.ppp = FALSE)
        # # plot(pts)
        # points(mean(pts$x), mean(pts$y), pch = 16)
        thiessen <- dirichlet(pts)
        plot(thiessen, add = TRUE, border = "purple")
      }
      if ("Delaunay" %in% input$stat) {
        # ctr <- centroid.owin(pts, as.ppp = FALSE)
        # # plot(pts)
        # points(mean(pts$x), mean(pts$y), pch = 16)
        thiessen <- delaunay(pts)
        plot(thiessen, add = TRUE, border = "orange")
      }
    }
    if (input$geom == "Line") {
      plot(pts)
      segments(x0 = pts$x[-length(pts$x)], 
               y0 = pts$y[-length(pts$y)], 
               x1 = pts$x[-1], 
               y1 = pts$y[-1],
               col = "darkgreen")
      if ("Minimum Bounding Circle" %in% input$stat) {
        mbc <- boundingcircle(pts)
        plot(mbc, add = TRUE)
      }
      if ("Minimum Bounding Rectangle" %in% input$stat) {
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
  # observeEvent(input$refresh, {
  #   shinyjs::reset("form")
  # })
}


shinyApp(ui, server)
