library(shiny)
library(shinyAce)

RCODE <- "my_sum <- function (a, b) {
a + b
}
my_sum( , )
"
nl <- stringr::str_count(RCODE, "\\n")

ui <- fluidPage(
  actionButton("eval", "run"),
  aceEditor("code", 
            mode = "r", 
            # height = "200px", 
            fontSize = 20,
            autoScrollEditorIntoView = TRUE,
            minLines = 2,
            maxLines = nl + 2,
            value = RCODE, 
            placeholder = RCODE),
  verbatimTextOutput("output")
)
server <- function(input, output, session) {
  output$output <- renderPrint({
    input$eval
    eval(parse(text = isolate(input$code)))
  })
}
shinyApp(ui = ui, server = server)