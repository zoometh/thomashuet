# Basic notion on point pattern analysis

library(shiny)
library(spatstat)
library(DT)
library(ggrepel)
library(sp)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("Pairwise comparisons"),
  h4("Kruskal-Wallis"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      # sliderInput("nb", "sample size", 3, 6, 5),
      sliderInput("seed", "set seed", 1, 10, 5)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Spatial distribution", 
                 plotOutput(outputId = "spatPlot",
                            height = "700px")),
        tabPanel("Distances", 
                 plotOutput(outputId = "linPlot", width = "100%")),
        tabPanel("Kruskal multiple", 
                 h5("p-values"), br(), 
                 DT::dataTableOutput(outputId = "dataframePlot", width = "50%")),
        tabPanel("Example", 
                 tags$iframe(style="height:2000px; width:100%", 
                             src="http://shinyserver.cfs.unipi.it:3838/teach/stats/bib/BIB-2167-Bego-Kruskal.pdf"))
      )
    )
  )
)

server <- function(input, output) {
  x1 <- seq(1:10)
  output$spatPlot <- renderPlot({
    # x1 <- seq(1:10)
    set.seed(input$seed)
    nb.pts <- 5
    # x1 <- seq(1:input$x1)
    margins <- .5
    catA <- data.frame(x = mean(x1) + runif(nb.pts, 0, 1),
                       y = mean(x1) + runif(nb.pts, 0, 1),
                       feat = rep("A", nb.pts),
                       row.names = paste0(rep("A", nb.pts),".",seq(1,nb.pts)))
    catB <- data.frame(x = mean(x1) + runif(nb.pts, 0, 3),
                       y = mean(x1) + runif(nb.pts, 0, 3),
                       feat = rep("B", nb.pts),
                       row.names = paste0(rep("B", nb.pts),".",seq(1,nb.pts)))
    catC <- data.frame(x = mean(x1) + runif(nb.pts, -1, 1),
                       y = mean(x1) + runif(nb.pts, -1, 1),
                       feat = rep("C", nb.pts),
                       row.names = paste0(rep("C", nb.pts),".",seq(1,nb.pts)))
    catD <- data.frame(x = mean(x1) + runif(nb.pts, 2, 5),
                       y = mean(x1) + runif(nb.pts, 2, 5),
                       feat = rep("D", nb.pts),
                       row.names = paste0(rep("D", nb.pts),".",seq(1,nb.pts)))
    df <- rbind(catA, catB, catC, catD)
    w <- as.owin(c(min(df$x) - margins, max(df$x) + margins,
                   min(df$y) - margins, max(df$y) + margins))
    x2 <- x1 <- seq(floor(w$yrange[1]), ceiling(w$yrange[2]))
    
    # TODO: add grid
    #print(x2)
    # x1 <- ceiling(w$yrange[1])
    # x2 <- ceiling(w$yrange[2])
    grid <- expand.grid(x1, x2)
    names(grid) <- c("x1", "x2")
    coordinates(grid) <- ~x1 + x2
    gridded(grid) <- TRUE
    
    plot(w, lwd = 3, main = "")
    plot(grid)
    
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
  })
  output$linPlot <- renderPlot({
    # TODO: simplify this redondant part by usng obsevre(), reactive(), etc.
    # x1 <- seq(1:10)
    set.seed(input$seed)
    nb.pts <- 5
    # nb.pts <- 4
    # x1 <- seq(1:input$x1)
    # x1 <- seq(1:10)
    catA <- data.frame(x = mean(x1) + runif(nb.pts, 0, 1),
                       y = mean(x1) + runif(nb.pts, 0, 1),
                       feat = rep("A", nb.pts),
                       row.names = paste0(rep("A", nb.pts),".",seq(1,nb.pts)))
    catB <- data.frame(x = mean(x1) + runif(nb.pts, 0, 3),
                       y = mean(x1) + runif(nb.pts, 0, 3),
                       feat = rep("B", nb.pts),
                       row.names = paste0(rep("B", nb.pts),".",seq(1,nb.pts)))
    catC <- data.frame(x = mean(x1) + runif(nb.pts, -1, 1),
                       y = mean(x1) + runif(nb.pts, -1, 1),
                       feat = rep("C", nb.pts),
                       row.names = paste0(rep("C", nb.pts),".",seq(1,nb.pts)))
    catD <- data.frame(x = mean(x1) + runif(nb.pts, 2, 5),
                       y = mean(x1) + runif(nb.pts, 2, 5),
                       feat = rep("D", nb.pts),
                       row.names = paste0(rep("D", nb.pts),".",seq(1,nb.pts)))
    df <- rbind(catA, catB, catC, catD)
    # distances to the mean
    dist.to.mean <- crossdist(df$x, df$y,
                              rep(mean(df$x), nrow(df)), 
                              rep(mean(df$x), nrow(df)))
    df$dist.to.mean <- dist.to.mean[ , 1]
    df.colors <- data.frame(feat = c("A", "B", "C", "D"),
                            color = c("red", "green", "blue", "pink"))
    df.rownames <- rownames(df)
    # print(df.rownames)
    df <- merge(df, df.colors, by = "feat", all.x = T)
    df$lbl <- df.rownames
    # rownames(df) <- df.rownames
    ggplot(df, aes(y = 0, x = dist.to.mean, color = color)) +
      geom_point(aes(size = 1.5)) +
      geom_text_repel(aes(color = "black", label = lbl), max.overlaps = Inf) +
      # geom_text(aes(y = 0, x = dist.to.mean, label = round(dist.to.mean, 2, cex = .5, vjust = .5))) +
      theme_bw() +
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) +
      scale_color_identity(guide = "legend", name = "features", breaks = df$color, label = df$feat)
  
  })
  # output$dataframePlot <- DT::renderDataTable({
  #   # observe({
  #   #   values$A
  #   # })
  # })
  output$dataframePlot <- DT::renderDataTable({
    # TODO: simplify this redondant part by usng obsevre(), reactive(), etc.
    # x1 <- seq(1:10)
    set.seed(input$seed)
    nb.pts <- 5
    # x1 <- seq(1:input$x1)
    # x1 <- seq(1:10)
    catA <- data.frame(x = mean(x1) + runif(nb.pts, 0, 1),
                       y = mean(x1) + runif(nb.pts, 0, 1),
                       feat = rep("A", nb.pts),
                       row.names = paste0(rep("A", nb.pts),".",seq(1,nb.pts)))
    catB <- data.frame(x = mean(x1) + runif(nb.pts, 0, 3),
                       y = mean(x1) + runif(nb.pts, 0, 3),
                       feat = rep("B", nb.pts),
                       row.names = paste0(rep("B", nb.pts),".",seq(1,nb.pts)))
    catC <- data.frame(x = mean(x1) + runif(nb.pts, -1, 1),
                       y = mean(x1) + runif(nb.pts, -1, 1),
                       feat = rep("C", nb.pts),
                       row.names = paste0(rep("C", nb.pts),".",seq(1,nb.pts)))
    catD <- data.frame(x = mean(x1) + runif(nb.pts, 2, 5),
                       y = mean(x1) + runif(nb.pts, 2, 5),
                       feat = rep("D", nb.pts),
                       row.names = paste0(rep("D", nb.pts),".",seq(1,nb.pts)))
    df <- rbind(catA, catB, catC, catD)
    # distances to the mean
    dist.to.mean <- crossdist(df$x, df$y,
                              rep(mean(df$x), nrow(df)), 
                              rep(mean(df$x), nrow(df)))
    df$dist.to.mean <- dist.to.mean[ , 1]
    km <- pairwise.wilcox.test(df$dist.to.mean, df$feat,
                               p.adjust.method = "BH")
    # values <- reactiveValues(A = datatable(round(km$p.value, 2)))
    km.res <- datatable(round(km$p.value, 2))
    # values
    km.res
    # datatable(round(km$p.value, 2))
    })
}

shinyApp(ui, server)
