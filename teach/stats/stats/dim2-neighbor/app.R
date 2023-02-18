# Basic notion on point pattern analysis
# and 2nd neighbor analysis

library(shiny)
library(spatstat)
library(sp)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
  tabsetPanel(
  tabPanel("Spatial indices", 
           h3("Main spatial indices"),
           h4("Fist-Order Neighborhood Analysis"),
           sidebarLayout(
             sidebarPanel(
               width = 3,
               checkboxGroupInput("stat",
                                  label = "Display",
                                  choices = c("Mean Center",
                                              "Central Feature",
                                              "Dirichlet",
                                              "Delaunay",
                                              "Convexhull",
                                              "Minimum Bounding Rectangle",
                                              "Minimum Bounding Circle"))
             ),
             mainPanel(
               fluidRow(plotOutput(outputId = "spatPlot",
                                   height = "600px",
                                   width = "800px")
               )
             )
           )
  ),
  tabPanel("K-ripley", 
           h3("K-ripley/L-Besag functions"),
           h4("Second-Order Neighborhood Analysis"),
           sidebarLayout(
             sidebarPanel(width = 2,
                          selectInput("ppa", 
                                      label = "Point Distribution",
                                      choices = c("Random", "Regular", "Clustered")),
                          # sliderInput("grid",
                          #             label = "number of divisions",
                          #             min = 5, max = 20, value = 10)
                          # tags$head(tags$style(HTML(".selectize-input {width: 300px;}")))
             ),
             mainPanel(
               fluidRow(
                 splitLayout(cellWidths = c("50%", "50%"), 
                             plotOutput(outputId = "gridPlot",
                                        height = "700px"), 
                             plotOutput(outputId = "LBesagPlot",
                                        height = "700px"))
               )
               
             )
           )
  )
  )
)

server <- function(input, output) {
  # - - - - - - - - - - - - - - - - - - - 
  # 1st
  x1 <- seq(1:10)
  w1 <- as.owin(c(min(x1), max(x1),
                 min(x1), max(x1)))
  plot(w1, lwd = 3, main = "")
  pts <- runifpoint(6, win = w1)
  ctr <- ppp(mean(pts$x), mean(pts$y), w1)
  # - - - - - - - - - - - - - - - - - - - 
  # 2nd
  x3 <- seq(1:10) - 0.5
  w <- as.owin(c(min(x3), max(x3),
                 min(x3), max(x3)))
  x4 <- x3
  grid <- expand.grid(x3, x4)
  names(grid) <- c("x3", "x4")
  coordinates(grid) <- ~x3 + x4
  gridded(grid) <- TRUE
  random.pt <- spsample(x = grid, n = 20, type = 'random')
  regular.pt <- spsample(x = grid, n = 20, type = 'regular')
  ori <- data.frame(spsample(x = grid, n = 1, type = 'random'))
  n.point <- 20 
  h <- rnorm(n.point, 1:2) 
  dxy <- data.frame(matrix(nrow = n.point, ncol = 2))
  angle <- runif(n = n.point, min = 0, max = 2*pi)
  dxy[ , 1] <- h*sin(angle)
  dxy[ , 2] <- h*cos(angle)
  cluster.pt <- data.frame(x = rep(NA, 20), y = rep(NA, 20))
  cluster.pt$x <- ori$coords.x1 + dxy$X1
  cluster.pt$y <- ori$coords.x2 + dxy$X2
  coordinates(cluster.pt)<-  ~ x+y
  # - - - - - - - - - - - - - - - - - - - 
  output$spatPlot <- renderPlot({
    # pts <- runifpoint(input$nbpts, win = w)
    # print(input$refresh)
    # if (input$geom == "Point") {
    plot(pts, pch = 16, cex = 1.5)
    if ("Minimum Bounding Circle" %in% input$stat) {
      mbc <- boundingcircle(pts)
      plot(mbc, add = TRUE, border = "blue")
    }
    if ("Minimum Bounding Rectangle" %in% input$stat) {
      mbr <- boundingbox(pts)
      plot(mbr, add = TRUE, border = "purple")
    }
    if ("Convexhull" %in% input$stat) {
      ch <- convexhull(pts)
      plot(ch, add = TRUE, border = "darkgrey", 
           lwd = 2)
    }
    if ("Central Feature" %in% input$stat) {
      # ctr <- centroid.owin(pts, as.ppp = FALSE)
      closest <- nncross(ctr, pts)
      ctf <- pts[closest$which]
      points(ctf$x, ctf$y, pch = 1, col="red",
             lwd = 3, cex = 3)
    }
    if ("Mean Center" %in% input$stat) {
      # ctr <- centroid.owin(pts, as.ppp = FALSE)
      # points(ctr$x, ctr$y, pch = 3, col = "red", cex = 2)
      points(ctr$x, ctr$y, pch = 3, col = "red", cex = 3)
    }
    if ("Dirichlet" %in% input$stat) {
      dirt <- dirichlet(pts)
      plot(dirt, add = TRUE, border = "purple")
    }
    if ("Delaunay" %in% input$stat) {
      deln <- delaunay(pts)
      plot(deln, add = TRUE, border = "orange")
    }
  })
  output$gridPlot <- renderPlot({
    if (input$ppa == "Random") {
      plot(grid)
      plot(random.pt, add = T, col = 'red', pch = 16, cex = 1.5)
    }
    else if (input$ppa == "Regular") {
      plot(grid)
      plot(regular.pt, add = T, col = 'blue', pch = 16, cex = 1.5)
    }
    else if (input$ppa == "Clustered") {
      plot(grid)
      plot(cluster.pt, add = T, col = 'green', pch = 16, cex = 1.5)
    }
  })
  output$LBesagPlot <- renderPlot({
    if (input$ppa == "Random") {
      Kpts <- ppp(coordinates(random.pt)[ , 1],
                  coordinates(random.pt)[ , 2],
                  window = w)
      # E <- envelope(Kpts, Lest, funargs = list(correction="Ripley"), nsim=100, VARIANCE=TRUE, verbose=FALSE)
      E <- envelope(Kpts, Lest, correction="Ripley", nsim = 100, VARIANCE = TRUE, verbose = FALSE)
      # E <- Lest(Kpts, correction = "Ripley") # makes the legend easy to read
      plot(E, xlab = "d (units)", ylab = "K(d)", main = "Random distribution")
    }
    else if (input$ppa == "Regular") {
      Kpts <- ppp(coordinates(regular.pt)[ , 1],
                  coordinates(regular.pt)[ , 2],
                  window = w)
      E <- envelope(Kpts, Lest, correction="Ripley", nsim = 100, VARIANCE = TRUE, verbose = FALSE)
      # L <- Lest(Kpts, correction = "Ripley")
      plot(E, xlab = "d (units)", ylab = "K(d)", main = "Regular distribution")
      # axis(1, at=c(0, (max(E$obs)+1)), labels=c("",""), lwd.ticks=0)
      # axis(1, at=seq(0 , (max(E$obs)+1), by=.5), lwd=0, lwd.ticks=1)
    }
    else if (input$ppa == "Clustered") {
      Kpts <- ppp(coordinates(cluster.pt)[ , 1],
                  coordinates(cluster.pt)[ , 2],
                  window = w)
      E <- envelope(Kpts, Lest, correction="Ripley", nsim = 100, VARIANCE = TRUE, verbose = FALSE)
      # plot(E)
      # L <- Lest(Kpts, correction = "Ripley")
      plot(E, xlab = "d (units)", ylab = "K(d)", main = "Clustered distribution")
    }
  })
}


shinyApp(ui, server)
