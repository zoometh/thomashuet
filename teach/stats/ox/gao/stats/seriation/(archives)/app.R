# Seriation

library(shiny)
library(seriation)
library(ca)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("seriate",
                  label = "Seriate",
                  choices = c("Raw dataframe",
                              "Seriated dataframe",
                              "Correspondance Analysis"),
                  selected = "Raw")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", 
                 plotOutput(outputId = "seriatePlot")),
        tabPanel("Dataframe", 
                 tableOutput(outputId = "dataframePlot"))
      )
    )
  )
)

server <- function(input, output) {
  seriat <- read.csv("https://raw.githubusercontent.com/zoometh/thomashuet/main/profiles/oxford/stats/GOA/seriation.csv")
  rownames(seriat) <- seriat$X
  seriat$X <- NULL
  seriat <- as.matrix(seriat)
  output$seriatePlot <- renderPlot({
    if (input$seriate == "Raw dataframe"){
      bertinplot(seriat, panel = panel.tiles)
    }
    else if (input$seriate == "Seriated dataframe"){
      o <- seriate(seriat, method = "BEA", control = list(rep = 20))
      bertinplot(seriat, o, panel = panel.tiles)
    }
    else if (input$seriate == "Correspondance Analysis"){
      my.ca <- ca(seriat)
      plot(my.ca)
    }
  })
  output$dataframePlot <- renderTable({
    as.data.frame(seriat)
  }, rownames = TRUE)
}


shinyApp(ui, server)