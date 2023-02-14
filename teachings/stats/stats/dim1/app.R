# Teaching app
# data with 1 dimension

library(shiny)
library(plotly)
library(ggplot2)
library(archdata)

data("Mesolithic")
# lbl <- paste0("site-", row.names(Mesolithic))


ui <- fluidPage(
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
      df <- data.frame(x = x,
                       y = rep(0, length(x)),
                       lbl = paste0("site-", row.names(Mesolithic), "<br> n = ", x)
      )
      # print(x)
      # lbl <- paste0("site-", row.names(Mesolithic))
      # print(lbl)
      if(input$blockaxe == "No"){
        gplot <- ggplot(df) +
          geom_point(aes(y = y, x = x, text = lbl)) +
          # geom_text(aes(y = rep(0, length(x)), x = x), label = lbl) +
          theme_bw() +
          theme(axis.title.y=element_blank(),
                axis.text.y=element_blank(),
                axis.ticks.y=element_blank())
      } 
      if(input$blockaxe == "Yes"){
        # print(x)
        gplot <- ggplot(df) +
          geom_point(aes(y = y, x = x, text = lbl)) +
          # geom_point(aes(y = rep(0, length(x)), x = x)) +
          theme_bw() +
          xlim(0, max(Mesolithic)) +
          theme(axis.title.y=element_blank(),
                axis.text.y=element_blank(),
                axis.ticks.y=element_blank())
      }
      # print(ggplotly(gplot))
    }
    if(input$diagram == "histogram"){
      # x <- input$category
      # bins <- seq(min(x), max(x), length.out = input$bins + 1)
      gplot <- plot_ly(Mesolithic,
                       x = ~get(input$category),
                       nbinsx = input$bins,
                       type = "histogram",
                       marker = list(color = 'rgb(158,202,225)',
                                     line = list(color = 'rgb(8,48,107)',
                                                 width = 1.5))) %>%
        layout(
          # line = list(color = 'rgb(8,48,107)', width = 1.5),
          xaxis = list(title = input$category),
          yaxis = list(title = 'n')
        )
    }
    ggplotly(gplot, tooltip="text")
  })
}

shinyApp(ui, server)
