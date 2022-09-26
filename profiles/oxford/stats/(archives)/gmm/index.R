# Momocs stuff

library(Momocs)
library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
    sliderInput("bot",
                label = "Select one bootle",
                min = 1, value = 1, max = length(bot)),
    selectInput("points",
                label = "Show points",
                choices = c("Yes","No"),
                selected = "No"),
    sliderInput("efourier",
                label = "number of harmonics",
                min = 2, value = 12, max = 30),
    selectInput("scale",
                label = "Scale",
                choices = c("Not centered, Not scaled",
                            "Centered",
                            "Centered-Scaled"),
                selected = "Not centered, Not scaled"),
    selectInput("gmm",
                label = "gmm",
                choices = c("PCA",
                            "CLUST",
                            "KMEANS"),
                selected = "PCA"),
    sliderInput("kmeans",
                label = "Number of Kmeans centers",
                min = 2, value = 3, max = 7)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Shape", 
                 plotOutput(outputId = "onePlot")),
        tabPanel("Shape Comparison", 
                 plotOutput(outputId = "stackPlot")),
        tabPanel("Shape Analysis", 
                 plotOutput(outputId = "gmmPlot"))
      )
    )
  )
)

server <- function(input, output) {
  output$onePlot <- renderPlot({
    a.bot <- bot[input$bot]
    if (input$points == "Yes"){
      ef <- efourier(a.bot, input$efourier)
      efi <- efourier_i(ef)
      coo_plot(efi, border='black', main = paste(names(bot)[input$bot], "\n",
                                                 input$efourier, " harmonics"),
               points = TRUE, pch = 16)
    }
    else if (input$points == "No"){
      ef <- efourier(a.bot, input$efourier)
      efi <- efourier_i(ef)
      coo_plot(efi, border='black', main = paste(names(bot)[input$bot], "\n",
                                                 input$efourier, " harmonics"))
      # coo_plot(a.bot)
    }
  })
  output$stackPlot <- renderPlot({
    if (input$scale == "Centered-Scaled") {
      bot %>%
        coo_center %>%
        coo_scale %>%
        coo_slidedirection("up") %T>%
        print() %>% 
        stack()
    }
    else if (input$scale == "Centered") {
      bot %>%
        coo_center %>%
        coo_slidedirection("up") %T>%
        print() %>% 
        stack()
    }
    else if (input$scale == "Not centered, Not scaled") {
      bot %>%
        coo_slidedirection("up") %T>%
        print() %>% 
        stack()
    }
  })
  output$gmmPlot <- renderPlot({
    if (input$gmm == "PCA") {
      bot.f <- efourier(bot, input$efourier)
      bot.p <- PCA(bot.f)
      plot(bot.p)
    }
    else if (input$gmm == "CLUST") {
      bot.f <- efourier(bot, input$efourier)
      bot.p <- CLUST(bot.f)
      plot(bot.p)
    }
    else if (input$gmm == "KMEANS") {
      bot.f <- efourier(bot, input$efourier)
      bot.f <- PCA(bot.f)
      KMEANS(bot.f, centers = input$kmeans)
    }
  })
}


shinyApp(ui, server)