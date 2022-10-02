# Teaching app
# data with 1 dimension

library(shiny)
library(plotly)
library(archdata)

data("Mesolithic")

ui <- fluidPage(
  selectInput("category", "category", 
              choices = colnames(Mesolithic), selected = "Microliths"),
  radioButtons("diagram", "points / histogram",
               choices = c("points", "histogram")
  ),
  radioButtons("blockaxe", "fixed x-axis",
               choices = c("Yes", "No")
  ),
  plotlyOutput("graph")
)

server <- function(input, output, session){
  output$graph <- renderPlotly({
    if(input$diagram == "points"){
      x <- Mesolithic[ , input$category]
      if(input$blockaxe == "No"){
        gplot <- ggplot() +
          geom_point(aes(y = rep(0, length(x)), x = x)) +
          theme_bw()
      } 
      else if(input$blockaxe == "Yes"){
        gplot <- ggplot() +
          geom_point(aes(y = rep(0, length(x)), x = x)) +
          theme_bw() +
          xlim(0, max(Mesolithic))
      }
      print(ggplotly(gplot))
    }
    else if(input$diagram == "histogram"){
      print(
        plot_ly(Mesolithic,
                x = ~get(input$category),
                type = "histogram") %>%
          layout(xaxis = list(
                   title = input$category),
                 yaxis = list(
                   title = 'n')
          )
      )
    }
  })
}

shinyApp(ui, server)
