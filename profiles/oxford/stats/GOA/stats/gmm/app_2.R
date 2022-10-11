# Momocs stuff

library(Momocs)
library(shiny)

my.dir <- dirname(rstudioapi::getSourceEditorContext()$path)
# outlines_combined_petrik <- readRDS(file = file.path(dirname(dirname(rstudioapi::getSourceEditorContext()$path)),"1_data","outlines_combined_petrik_2018.RDS"))
arrow.heads <- readRDS(file = file.path(my.dir, "arrowheads.RDS"))

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Single", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 sliderInput("arrow.heads",
                             label = "Select one arrow",
                             min = 1, value = 1, max = length(arrow.heads), step = 1),
                 selectInput("points",
                             label = "Show points",
                             choices = c("Yes","No"),
                             selected = "No"),
                 sliderInput("efourier",
                             label = "number of harmonics",
                             min = 2, value = 10, max = 20)
               ),
               mainPanel("Shape", 
                         plotOutput(outputId = "onePlot")
               )
             )
    ),
    tabPanel("Compare", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 selectInput("scale",
                             label = "Scale",
                             choices = c("Not centered, Not scaled",
                                         "Centered",
                                         "Centered-Scaled"),
                             selected = "Not centered, Not scaled")
               ),
               mainPanel("Shape Comparison", 
                         plotOutput(outputId = "stackPlot")
               )
             )
    ),
    tabPanel("Classify", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 selectInput("gmm",
                             label = "gmm",
                             choices = c("PCA",
                                         "CLUST",
                                         "KMEANS"),
                             selected = "PCA"),
                 sliderInput("kmeans",
                             label = "Number of Kmeans centers",
                             min = 2, value = 3, max = 7, step = 1)
               ),
               mainPanel("Shape Analysis", 
                         plotOutput(outputId = "gmmPlot"))
             )
    )
  )
)

server <- function(input, output) {
  output$onePlot <- renderPlot({
    idx <- input$arrow.heads
    idx <- idx + .5
    a.arrow.heads <- arrow.heads[idx]
    harm <- input$efourier
    ef <- efourier(a.arrow.heads, harm)
    efi <- efourier_i(ef)
    # print(input$arrow.heads)
    # print(input$efourier)
    if (input$points == "Yes"){
      # ef <- efourier(a.arrow.heads, input$efourier)
      # efi <- efourier_i(ef)
      coo_plot(efi, 
               borders = arrow.heads$color, 
               main = paste(names(arrow.heads)[input$arrow.heads], "\n",
                                                 input$efourier, " harmonics"),
               points = TRUE,
               pch = 16)
    }
    else if (input$points == "No"){
      # ef <- efourier(a.arrow.heads, input$efourier)
      # # print(a.arrow.heads)
      # # print(input$efourier)
      # efi <- efourier_i(ef)
      coo_plot(efourier_i(ef), 
               borders = arrow.heads$color, 
               main = paste(names(arrow.heads)[input$arrow.heads], "\n",
                                                 input$efourier, " harmonics"))
      # coo_plot(a.arrow.heads)
    }
  })
  output$stackPlot <- renderPlot({
    if (input$scale == "Centered-Scaled") {
      arrow.heads %>%
        coo_center %>%
        coo_scale %>%
        coo_slidedirection("up") %T>%
        print() %>% 
        stack(borders = arrow.heads$color)
    }
    else if (input$scale == "Centered") {
      arrow.heads %>%
        coo_center %>%
        coo_slidedirection("up") %T>%
        print() %>% 
        stack(borders = arrow.heads$color)
    }
    else if (input$scale == "Not centered, Not scaled") {
      arrow.heads %>%
        coo_slidedirection("up") %T>%
        print() %>% 
        stack(borders = arrow.heads$color)
    }
  })
  output$gmmPlot <- renderPlot({
    if (input$gmm == "PCA") {
      arrow.heads.f <- efourier(arrow.heads, input$efourier)
      arrow.heads.p <- PCA(arrow.heads.f)
      plot(arrow.heads.p)
    }
    else if (input$gmm == "CLUST") {
      arrow.heads.f <- efourier(arrow.heads, input$efourier)
      arrow.heads.p <- CLUST(arrow.heads.f)
      plot(arrow.heads.p)
    }
    else if (input$gmm == "KMEANS") {
      arrow.heads.f <- efourier(arrow.heads, input$efourier)
      arrow.heads.f <- PCA(arrow.heads.f)
      KMEANS(arrow.heads.f, centers = input$kmeans)
    }
  })
}

shinyApp(ui, server)

# a.arrow.heads <- arrow.heads[1]
# ef <- efourier(a.arrow.heads, 12)
# efi <- efourier_i(ef)
# coo_plot(efi, border='black', main = paste(names(arrow.heads)[1], "\n",
#                                            12, " harmonics"),
#          points = TRUE, pch = 16)
