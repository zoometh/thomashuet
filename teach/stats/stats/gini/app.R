library(ineq)
library(shiny)
library(ggplot2)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(),
  h3("Gini coefficient"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      radioButtons("serie",
                   label = "Dataset",
                   choices = c("serie 1",
                               "serie 2"),
                   selected = "serie 1")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Lorenz curve", 
                 verbatimTextOutput("outserie"),
                 plotOutput("lorenz",
                            height = "500px")), 
        tabPanel("Boxplot",
                 verbatimTextOutput("outserie1"),
                 verbatimTextOutput("outserie2"),
                 plotOutput("boxplot",
                            height = "500px")),
        tabPanel("Example", 
                 tags$iframe(style="height:2000px; width:100%", 
                             src="http://shinyserver.cfs.unipi.it:3838/teach/stats/bib/BIB-3620-Gini.pdf"))
      )
    )
  )
)

server <- function(input, output) {
  set.seed(1)
  serie.1 <- sort(round(runif(10, 0, 200)))
  serie.2 <- sort(round(runif(10, 0, 30)))
  output$outserie <- renderText({
    if (input$serie == "serie 1"){
      serie <- serie.1
    }
    if (input$serie == "serie 2"){
      serie <- serie.2
    }
    paste0(input$serie, ": ", paste0(serie, collapse = ", "))
  })
  output$lorenz <- renderPlot({
    if (input$serie == "serie 1"){
      plot(Lc(serie.1), main =  paste0("Gini: ", round(ineq(serie.1,type="Gini"), 2)), sub = input$serie)
    }
    if (input$serie == "serie 2"){
      plot(Lc(serie.2), main =  paste0("Gini: ", round(ineq(serie.2,type="Gini"), 2)), sub = input$serie)
    }
  })
  output$boxplot <- renderPlot({
    df.serie.1 <- data.frame(serie.1)
    df.serie.1$serie <- "serie 1"
    colnames(df.serie.1) <- c("val", "serie")
    df.serie.2 <- data.frame(serie.2)
    df.serie.2$serie <- "serie 2"
    colnames(df.serie.2) <- c("val", "serie")
    df <- rbind(df.serie.1, df.serie.2)
    ggplot(df, aes(x = serie, y = val)) + 
      geom_boxplot() +
      geom_point() +
      stat_summary(fun = mean, geom = "point", shape = 3, size = 4, color = "red") +
      theme_bw() +
      coord_flip() +
      xlab("")
  })
  output$outserie1 <- renderText({paste0("serie 1: ", paste0(serie.1, collapse = ", "))})
  output$outserie2 <- renderText({paste0("serie 2: ", paste0(serie.2, collapse = ", "))})
}


shinyApp(ui, server)


