# normal distribution

library(ggplot2)

ui <- fluidPage(
  sliderInput("mean",
              label = "mean",
              min = -2, value = 0, max = +2),
  sliderInput("sd",
              label = "standard deviation",
              min = .4, value = .4, max = 5),
  plotOutput("graph")
)

server <- function(input, output) {
  output$graph <- renderPlot({
    x <- seq(-5, 5, length = 1000)
    y <- dnorm(x, mean = input$mean, sd = input$sd)
    ggplot() +
      geom_line(aes(x, y), color = "blue") +
      ylim(0, 1) +
      theme_bw()
  })
}

shinyApp(ui, server)
