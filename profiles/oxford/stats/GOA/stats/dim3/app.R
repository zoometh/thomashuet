# Teaching app
# data with 3 dimensions

library(plotly)
library(jsonlite)

# df.isotop$Pb206_Pb204.perc <- round((df.isotop$Pb206_Pb204/(df.isotop$Pb206_Pb204 + df.isotop$Pb207_Pb204 + df.isotop$Pb208_Pb204) * 100), 2)
# df.isotop$Pb207_Pb204.perc <- round((df.isotop$Pb207_Pb204/(df.isotop$Pb206_Pb204 + df.isotop$Pb207_Pb204 + df.isotop$Pb208_Pb204) * 100), 2)
# df.isotop$Pb208_Pb204.perc <- round((df.isotop$Pb208_Pb204/(df.isotop$Pb206_Pb204 + df.isotop$Pb207_Pb204 + df.isotop$Pb208_Pb204) * 100), 2)
# 
# write.csv2(df.isotop, paste0(getwd(), "/dfisotops.csv"))

df.isotop <- read.csv2(paste0(dirname(rstudioapi::getSourceEditorContext()$path),
                              "/dfisotops.csv"), sep = ";")
df.isotop$lbl <- paste0(df.isotop$num, "\n", 
                        "Pb206/204: ", df.isotop$Pb206_Pb204.perc, "% \n",
                        "Pb207/204: ", df.isotop$Pb207_Pb204.perc, "% \n",
                        "Pb208/204: ", df.isotop$Pb208_Pb204.perc, "%")

# # axis layout
# axis <- function(title) {
#   list(
#     title = title,
#     titlefont = list(
#       size = 20
#     ),
#     tickfont = list(
#       size = 15
#     ),
#     tickcolor = 'rgba(0,0,0,0)',
#     ticklen = 5
#   )
# }

ui <- fluidPage(
  # tags$style('.container-fluid {
  #                            background-color: #000000;
  #             }'),
  checkboxGroupInput("objects", "objects",
                     choices = c("golasecca", "hochdorf"),
                     selected = "hochdorf"
  ),
  checkboxGroupInput("mines", "mines",
                     choices = c("France", "Iberian Peninsula", "Switzerland"),
                     selected = "France"
  ),
  plotlyOutput("graph")
)

server <- function(input, output, session){
  output$graph <- renderPlotly({
    df.isotop.filtered <- df.isotop[df.isotop$object %in% c(input$objects, input$mines), ]
    min206 <- min(df.isotop$Pb206_Pb204)
    min207 <- min(df.isotop$Pb207_Pb204)
    min208 <- min(df.isotop$Pb208_Pb204)
    fig <- plot_ly(df.isotop.filtered) %>%
      add_trace(
        type = 'scatterternary',
        mode = 'markers',
        a = ~Pb206_Pb204.perc,
        b = ~Pb207_Pb204.perc,
        c = ~Pb208_Pb204.perc,
        text = ~lbl,
        hoverinfo='text',
        marker = list(
          # symbol = ~symbol,
          symbols = 'square',# unique(df.isotop$symbol),
          color = ~color.object,
          size = 10,
          line = list('width' = 1, color = 'black')
        )
      ) %>% 
      layout(
        title = "Relative percentages of lead isotops",
        ternary = list(
          legend = list(orientation = "h"),
          sum = 100,
          aaxis = list(min = min206, title = 'Pb206/Pb204'),
          baxis = list(min = min207, title = 'Pb207/Pb204'),
          caxis = list(min = min208, title = 'Pb208/Pb204')
          # aaxis = list(min = 24, title = 'Pb206/Pb204'),
          # baxis = list(min = 20, title = 'Pb207/Pb204'),
          # caxis = list(min = 48, title = 'Pb208/Pb204')
        )
      )
    print(fig)
  })
}

shinyApp(ui, server)