# Basic notion on point pattern analysis

library(shiny)
library(spatstat)
library(DT)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("XXXX"),
  h4("yyyyy"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      sliderInput("x1", "window size", 5, 15, 10)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Spatial distribution", 
                 plotOutput(outputId = "spatPlot",
                            height = "700px")),
        tabPanel("Kruskal multiple", 
                 DT::dataTableOutput(outputId = "dataframePlot"))
      )
    )
  )
)

server <- function(input, output) {
  # nb.pts <- 4
  # margins <- .5
  # catA <- data.frame(x = mean(x1)+runif(nb.pts, 0, 1),
  #                    y = mean(x1)+runif(nb.pts, 0, 1),
  #                    feat = rep("A", nb.pts),
  #                    row.names = paste0(rep("A", nb.pts),".",seq(1,nb.pts)))
  # catB <- data.frame(x = mean(x1)+runif(nb.pts, 0, 3),
  #                    y = mean(x1)+runif(nb.pts, 0, 3),
  #                    feat = rep("B", nb.pts),
  #                    row.names = paste0(rep("B", nb.pts),".",seq(1,nb.pts)))
  # catC <- data.frame(x = mean(x1)+runif(nb.pts, 1, 5),
  #                    y = mean(x1)+runif(nb.pts, 1, 5),
  #                    feat = rep("C", nb.pts),
  #                    row.names = paste0(rep("C", nb.pts),".",seq(1,nb.pts)))
  # catD <- data.frame(x = mean(x1)+runif(nb.pts, 3, 5),
  #                    y = mean(x1)+runif(nb.pts, 3, 5),
  #                    feat = rep("D", nb.pts),
  #                    row.names = paste0(rep("D", nb.pts),".",seq(1,nb.pts)))
  # df <- rbind(catA, catB, catC, catD)
  # 
  # # distances to the mean
  # dist.to.mean <- crossdist(df$x, df$y,
  #                           rep(mean(df$x), nrow(df)), 
  #                           rep(mean(df$x), nrow(df)))
  # df$dist.to.mean <- dist.to.mean[ , 1]
  # km <- pairwise.wilcox.test(df$dist.to.mean, df$feat,
  #                            p.adjust.method = "BH")
  # km.res <- datatable(km$p.value)

  output$spatPlot <- renderPlot({
    x1 <- seq(1:input$x1)
    nb.pts <- 4
    margins <- .5
    catA <- data.frame(x = mean(x1)+runif(nb.pts, 0, 1),
                       y = mean(x1)+runif(nb.pts, 0, 1),
                       feat = rep("A", nb.pts),
                       row.names = paste0(rep("A", nb.pts),".",seq(1,nb.pts)))
    catB <- data.frame(x = mean(x1)+runif(nb.pts, 0, 3),
                       y = mean(x1)+runif(nb.pts, 0, 3),
                       feat = rep("B", nb.pts),
                       row.names = paste0(rep("B", nb.pts),".",seq(1,nb.pts)))
    catC <- data.frame(x = mean(x1)+runif(nb.pts, 1, 5),
                       y = mean(x1)+runif(nb.pts, 1, 5),
                       feat = rep("C", nb.pts),
                       row.names = paste0(rep("C", nb.pts),".",seq(1,nb.pts)))
    catD <- data.frame(x = mean(x1)+runif(nb.pts, 3, 5),
                       y = mean(x1)+runif(nb.pts, 3, 5),
                       feat = rep("D", nb.pts),
                       row.names = paste0(rep("D", nb.pts),".",seq(1,nb.pts)))
    df <- rbind(catA, catB, catC, catD)
    w <- as.owin(c(min(df$x) - margins, max(df$x) + margins,
                   min(df$y) - margins, max(df$y) + margins))
    plot(w, lwd = 3, main = "")
    
    # mean
    points(x = mean(df$x), 
           y = mean(df$y), 
           pch = 16, cex = 4, col = "black")
    src <- ppp(mean(df$x), mean(df$y), w)
    text(src, labels = "S", cex = 1.5, col = "white")
    
    # features
    points(x = catA$x, 
           y = catA$y, 
           pch = 16, cex = 2, col = "red")
    points(x = catB$x, 
           y = catB$y, 
           pch = 16, cex = 2, col = "green")
    points(x = catC$x, 
           y = catC$y, 
           pch = 16, cex = 2, col = "blue")
    points(x = catD$x, 
           y = catD$y, 
           pch = 16, cex = 2, col = "pink")
    pts <- ppp(df$x, df$y, w)
    text(pts, labels = rownames(df), cex = 1, pos = 1)
    
    # distances to the mean
    dist.to.mean <- crossdist(df$x, df$y,
                              rep(mean(df$x), nrow(df)), 
                              rep(mean(df$x), nrow(df)))
    df$dist.to.mean <- dist.to.mean[ , 1]
    km <- pairwise.wilcox.test(df$dist.to.mean, df$feat,
                               p.adjust.method = "BH")
    km.res <- datatable(km$p.value)
  })
  output$dataframePlot <- DT::renderDataTable({
    datatable(km$p.value)
    })
}

shinyApp(ui, server)
