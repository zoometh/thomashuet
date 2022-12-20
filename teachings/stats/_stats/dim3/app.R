# Teaching app
# data with 3 dimensions

library(plotly)

# df.isotop$Pb206_Pb204.perc <- round((df.isotop$Pb206_Pb204/(df.isotop$Pb206_Pb204 + df.isotop$Pb207_Pb204 + df.isotop$Pb208_Pb204) * 100), 2)
# df.isotop$Pb207_Pb204.perc <- round((df.isotop$Pb207_Pb204/(df.isotop$Pb206_Pb204 + df.isotop$Pb207_Pb204 + df.isotop$Pb208_Pb204) * 100), 2)
# df.isotop$Pb208_Pb204.perc <- round((df.isotop$Pb208_Pb204/(df.isotop$Pb206_Pb204 + df.isotop$Pb207_Pb204 + df.isotop$Pb208_Pb204) * 100), 2)
# 
# write.csv2(df.isotop, paste0(getwd(), "/dfisotops.csv"))

dfisotops <- read.csv2(paste0(getwd(), "/dfisotops.csv"), sep = ";") # server
# dfisotops <- read.csv2(paste0(getwd(), "/dfisotops.csv"),  sep = ";") # locally
dfisotops$Pb206_Pb204.perc <- (dfisotops$Pb206_Pb204/(dfisotops$Pb206_Pb204 + dfisotops$Pb207_Pb204 + dfisotops$Pb208_Pb204))*100
dfisotops$Pb207_Pb204.perc <- (dfisotops$Pb207_Pb204/(dfisotops$Pb206_Pb204 + dfisotops$Pb207_Pb204 + dfisotops$Pb208_Pb204))*100  
dfisotops$Pb208_Pb204.perc <- (dfisotops$Pb208_Pb204/(dfisotops$Pb206_Pb204 + dfisotops$Pb207_Pb204 + dfisotops$Pb208_Pb204))*100 
dfisotops$lbl <- paste0(dfisotops$num, "\n", 
                        "<sup>206/204</sup>Pb: ", round(dfisotops$Pb206_Pb204.perc, 2), "% \n",
                        "<sup>207/204</sup>Pb: ", round(dfisotops$Pb207_Pb204.perc, 2), "% \n",
                        "<sup>208/204</sup>Pb: ", round(dfisotops$Pb208_Pb204.perc, 2), "%")
m <- list(
  l = 50,
  r = 50,
  b = 50,
  t = 100,
  pad = 20
)

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(),
  # tags$style('.container-fluid {
  #                            background-color: #000000;
  #             }'),
  h3("Relative % of lead isotops for mines and EIA items"),
  
  tabPanel("Single", fluid = TRUE,
           sidebarLayout(
             sidebarPanel(
               width = 2,
               checkboxGroupInput("objects", "objects",
                                  choices = c("golasecca", "hochdorf"),
                                  selected = "hochdorf"
               ),
               checkboxGroupInput("mines", "mines",
                                  choices = c("France", "Iberian Peninsula", "Switzerland"),
                                  selected = "France"
               )
             ),
             mainPanel("Relative percentages of lead isotops", 
                       plotlyOutput("graph",
                                    height = "600px")
             )
           )
  )
  
  
  # checkboxGroupInput("objects", "objects",
  #                    choices = c("golasecca", "hochdorf"),
  #                    selected = "hochdorf"
  # ),
  # checkboxGroupInput("mines", "mines",
  #                    choices = c("France", "Iberian Peninsula", "Switzerland"),
  #                    selected = "France"
  # ),
  # plotlyOutput("graph",
  #              height = "600px")
)

server <- function(input, output, session){
  output$graph <- renderPlotly({
    df.isotop.filtered <- dfisotops[dfisotops$object %in% c(input$objects, input$mines), ]
    min206 <- min(df.isotop.filtered$Pb206_Pb204.perc)
    min207 <- min(df.isotop.filtered$Pb207_Pb204.perc)
    min208 <- min(df.isotop.filtered$Pb208_Pb204.perc)
    fig <- plot_ly(df.isotop.filtered) %>%
      add_trace(
        type = 'scatterternary',
        mode = 'markers',
        a = ~Pb206_Pb204.perc,
        b = ~Pb207_Pb204.perc,
        c = ~Pb208_Pb204.perc,
        text = ~lbl,
        hoverinfo = 'text',
        #opacity = .3, 
        marker = list(
          # symbol = ~symbol,
          symbols = 'square',# unique(df.isotop$symbol),
          color = ~color.object,
          size = 10,
          opacity = .5,
          line = list('width' = 1, 
                      color = '#00000070')
        )
      ) %>% 
      layout(
        # title = "Relative percentages of lead isotops",
        margin = m,
        # title = list(orientation = "h",   # show entries horizontally
        #              xanchor = "center",  # use center of legend as anchor
        #              x = 0.5,
        #              text = "Relative percentages of lead isotops"),
        ternary = list(
          legend = list(orientation = "h"),
          sum = 100,
          aaxis = list(min = min206, title = '<sup>206</sup>Pb/<sup>204</sup>Pb'),
          baxis = list(min = min207, title = '<sup>207</sup>Pb/<sup>204</sup>Pb'),
          caxis = list(min = min208, title = '<sup>208</sup>Pb/<sup>204</sup>Pb')
        )
      )
    print(fig)
  })
}

shinyApp(ui, server)