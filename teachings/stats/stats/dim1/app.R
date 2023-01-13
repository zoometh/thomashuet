# Teaching app
# data with 1 dimension

library(shiny)
library(plotly)
library(ggplot2)
library(archdata)

data("Mesolithic")

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("British Mesolithic assemblages (n = 33 sites)"),
  fluidRow(column(3, selectInput("category", "category", 
                                 choices = colnames(Mesolithic), selected = "Microliths")),
           column(3, radioButtons("blockaxe", "fixed x-axis",
                                  choices = c("Yes", "No"), selected = "Yes"
           ))),
  plotlyOutput("graph",
               height = "400px"),
  fluidRow(column(3, radioButtons("diagram", "points / histogram",
                                  choices = c("points", "histogram"), selected = "points")),
           column(3, sliderInput(inputId = "bins",
                                 label = "Number of bins:",
                                 min = 1,
                                 max = 12,
                                 value = 8)))
)

server <- function(input, output, session){
  output$graph <- renderPlotly({
    if(input$diagram == "points"){
      x <- Mesolithic[ , input$category]
      #lbls <- paste0("site-", row.names(Mesolithic), "<br>", as.character(x))
      if(input$blockaxe == "No"){
        gplot <- ggplot() +
          geom_point(aes(y = rep(0, length(x)), x = x)) +
          theme_bw()
      } 
      else if(input$blockaxe == "Yes"){
        # print(x)
        gplot <- ggplot() +
          geom_point(aes(y = rep(0, length(x)), x = x)) +
          theme_bw() +
          xlim(0, max(Mesolithic))
      }
      # print(ggplotly(gplot))
      gplot
    }
    else if(input$diagram == "histogram"){
      # x <- input$category
      # bins <- seq(min(x), max(x), length.out = input$bins + 1)
      print(
        plot_ly(Mesolithic,
                x = ~get(input$category),
                nbinsx = input$bins,
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
