library(shiny)
library(shinyAce)

RCODE <- "df <- data.frame(
  num=1:4,
  let=LETTERS[2:5],
  rand=rnorm(4)
)
df
"
nl <- stringr::str_count(RCODE, "\\n")

ui <- fluidPage(
  actionButton("eval", "run"),
  aceEditor("code", 
            mode = "r", 
            # height = "200px", 
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