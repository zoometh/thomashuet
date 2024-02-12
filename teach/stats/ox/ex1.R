library(shiny)
library(shinyAce)

RCODE <- "summary(cars)\n1 + 1"
RCODE <- "print('hello')"

ui <- fluidPage(
  # titlePanel("Run Custom R Code with Line Numbers"),
  aceEditor(
    "code", 
    "Enter R code:", 
    value = RCODE, 
    mode = "r",  # Set the syntax highlighting mode to R
    theme = "github",  # Set theme, you can choose others as well
    height = "200px",  # Set the height of the editor
    fontSize = 14,  # Set the font size
    placeholder = RCODE
  ),
  actionButton("run", "Run"),
  verbatimTextOutput("result")
)

server <- function(input, output, session) {
  observeEvent(input$run, {
    # Attempt to safely evaluate user code
    tryCatch({
      result <- eval(parse(text = input$code))
      output$result <- renderPrint({ result })
    }, error = function(e) {
      output$result <- renderPrint({ paste("Error:", e$message) })
    })
  })
}

shinyApp(ui = ui, server = server)


