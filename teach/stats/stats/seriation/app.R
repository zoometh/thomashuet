# Seriation

library(shiny)
library(DT)
library(seriation)
library(ca)



seriat <- read.csv("https://raw.githubusercontent.com/keltoskytoi/Multivariate_Statistics_Szentloerinc/master/DATA/fibulae.csv", row.name = 1)

datas <- datatable(
  seriat, extensions = 'Buttons', options = list(
    dom = 'Blfrtip',
    buttons = c('copy', 'csv', 'excel'),
    lengthMenu = list(c(30, 50, -1), 
                      c('30', '50', 'All')),
    paging = T)
)

seriat <- as.matrix(seriat)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(),
  h3("LIA cemetery of Szentlőrinc, Hungary"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
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
                 plotOutput(outputId = "seriatePlot",
                            height = "700px")),
        tabPanel("Dataframe", 
                 DT::dataTableOutput(outputId = "dataframePlot")),
        # tabPanel("Publication", 
        #          tags$iframe(style="height:2000px; width:100%", 
        #                      src="http://shinyserver.cfs.unipi.it:3838/teach/stats/bib/BIB-3570-Multivariate.pdf")),
        tabPanel("Other example", 
                 tags$iframe(style="height:2000px; width:100%", 
                             src="http://shinyserver.cfs.unipi.it:3838/teach/stats/bib/BIB-1396-Seriation-Duraton.pdf"))
      )
    )
  )
)

server <- function(input, output) {
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
  output$dataframePlot <- DT::renderDataTable({
    datas})
}


shinyApp(ui, server)