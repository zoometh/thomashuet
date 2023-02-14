# Random, vs Regular, vs Clustered +
# L-Besag

library(shiny)
library(sp)
library(spatstat)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("K-ripley/L-Besag functions"),
  h4("Second-Order Neighborhood Analysis"),
  sidebarLayout(
    sidebarPanel(width = 2,
      selectInput("ppa", 
                  label = "Point Pattern Analysis",
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

server <- function(input, output) {
  x1 <- seq(1:10) - 0.5
  w <- as.owin(c(min(x1), max(x1),
                 min(x1), max(x1)))
  x2 <- x1
  grid <- expand.grid(x1, x2)
  names(grid) <- c("x1", "x2")
  coordinates(grid) <- ~x1 + x2
  gridded(grid) <- TRUE
  random.pt <- spsample(x = grid, n= 20, type = 'random')
  regular.pt <- spsample(x = grid, n= 20, type = 'regular')
  ori <- data.frame(spsample(x = grid, n= 1, type = 'random'))
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

# E <- envelope(Kpts, Lest, correction="Ripley", nsim=100, VARIANCE=TRUE)
# plot(E)
