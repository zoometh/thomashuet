# Teaching app
# data with 3 dimensions

Sys.setlocale("LC_ALL", "C")

library(plotly)
# library(NbClust)

dfisotops <- read.csv2("https://raw.githubusercontent.com/zoometh/thomashuet/main/teach/stats/stats/dim3/dfisotops.csv", sep = ";") # GH
# dfisotops$X <- NULL
# dfisotops <- read.csv2(paste0(getwd(), "/dfisotops.csv"), sep = ";") # server
# dfisotops <- read.csv2(paste0(getwd(), "/dfisotops.csv"),  sep = ";") # locally
# centers.best <- NbClust(data = dfisotops[, c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")],
#                           distance = "euclidean",
#                           method = "ward.D2",
#                           index = c("gap", "silhouette"))
# nb.centers.best <- centers.best$Best.nc[1, "Gap"]


dfkmeans <- kmeans(x = dfisotops[, c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")],
                   centers = 3,
                   nstart = 20)
dfisotops$cluster <- dfkmeans$cluster

#TODO: pass this assignations to itineRis 'symbol' calculation
dfisotops$symbol <- NULL
symbols.default <- c('circle', 'square', 'triangle', 'diamond', 'star', 'cross')
objects.used <- as.character(unique(dfisotops$object))
symbols.used <- symbols.default[c(1:length(objects.used))]
symbols.objects <- data.frame(object = objects.used,
                              symbol = symbols.used)

dfisotops <- merge(dfisotops, symbols.objects, by = "object", all.x = TRUE)

dfisotops$Pb206_Pb204.perc <- (dfisotops$Pb206_Pb204/(dfisotops$Pb206_Pb204 + dfisotops$Pb207_Pb204 + dfisotops$Pb208_Pb204))*100
dfisotops$Pb207_Pb204.perc <- (dfisotops$Pb207_Pb204/(dfisotops$Pb206_Pb204 + dfisotops$Pb207_Pb204 + dfisotops$Pb208_Pb204))*100  
dfisotops$Pb208_Pb204.perc <- (dfisotops$Pb208_Pb204/(dfisotops$Pb206_Pb204 + dfisotops$Pb207_Pb204 + dfisotops$Pb208_Pb204))*100 

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
  # h3("Relative % of lead isotopes for mines and EIA items"),
  
  tabPanel("Single", fluid = TRUE,
           sidebarLayout(
             position = "right",
             sidebarPanel(
               width = 2,
               checkboxGroupInput("objects", "objects",
                                  choices = c("golasecca", "hochdorf"),
                                  selected = "hochdorf"
               ),
               checkboxGroupInput("mines", "mines",
                                  choices = c("France", "Iberian Peninsula", "Switzerland"),
                                  selected = "France"
               ),
               sliderInput("kmeans", "kmeans", min = 1, max = 5, value = 2)
               # h4("best number of clusters:"),
               # textOutput("bestnbcenters")
             ),
             mainPanel(#"Relative percentages of lead isotops", 
               plotlyOutput("graph",
                            height = "800px")
             )
           )
  )
)

server <- function(input, output, session){
  # observe({
  #   df.isotop.filtered <- dfisotops[dfisotops$object %in% c(input$objects, input$mines), ]
  #   # best number of clusters
  #   centers.best <- NbClust(data = dfisotops[, c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")],
  #                           distance = "euclidean",
  #                           method = "ward.D2",
  #                           index = c("gap", "silhouette"))
  #   updateTextInput(session, inputId = "bestnbcenters", label = centers.best$Best.nc[1, "Gap"])
  # })
  # output$bestnbcenters <- renderText({
  #   df.isotop.filtered <- dfisotops[dfisotops$object %in% c(input$objects, input$mines), ]
  #   # best number of clusters
  #   centers.best <- NbClust(data = dfisotops[, c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")],
  #                           distance = "euclidean",
  #                           method = "ward.D2",
  #                           index = c("gap", "silhouette"))
  #   centers.best$Best.nc[1, "Gap"]
  # 
  # })
  output$graph <- renderPlotly({
    df.isotop.filtered <- dfisotops[dfisotops$object %in% c(input$objects, input$mines), ]
    min206 <- min(df.isotop.filtered$Pb206_Pb204.perc)
    min207 <- min(df.isotop.filtered$Pb207_Pb204.perc)
    min208 <- min(df.isotop.filtered$Pb208_Pb204.perc)
    # # best number of clusters
    # centers.best <- NbClust(data = dfisotops[, c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")],
    #                         distance = "euclidean",
    #                         method = "ward.D2",
    #                         index = c("gap", "silhouette"))
    # nb.centers.best <- centers.best$Best.nc[1, "Gap"]
    # kmeans with the user's nb of clusters
    dfkmeans <- kmeans(x = df.isotop.filtered[, c("Pb206_Pb204", "Pb207_Pb204", "Pb208_Pb204")], 
                       centers = input$kmeans, 
                       nstart = 20)
    df.isotop.filtered$cluster <- dfkmeans$cluster
    df.isotop.filtered$lbl <- paste0(df.isotop.filtered$num, "\n", 
                                     "<sup>206/204</sup>Pb: ", round(df.isotop.filtered$Pb206_Pb204.perc, 2), "% \n",
                                     "<sup>207/204</sup>Pb: ", round(df.isotop.filtered$Pb207_Pb204.perc, 2), "% \n",
                                     "<sup>208/204</sup>Pb: ", round(df.isotop.filtered$Pb208_Pb204.perc, 2), "%")
    fig <- plot_ly(data = df.isotop.filtered, 
                   name = ~object, 
                   color = ~color.object) %>%
      add_trace(
        type = 'scatterternary',
        mode = 'markers',
        a = ~Pb206_Pb204.perc,
        b = ~Pb207_Pb204.perc,
        c = ~Pb208_Pb204.perc,
        # text = ~lbl,
        # hoverinfo = 'text',
        #opacity = .3,
        marker = list(
          symbol = ~symbol,
          # symbols = 'square',# unique(df.isotop$symbol),
          # color = ~color.object,
          
          size = 10,
          opacity = .7,
          line = list('width' = 1,
                      color = '#00000070')
        )) %>%
      add_trace(
        type = 'scatterternary',
        mode = 'text',
        a = ~Pb206_Pb204.perc,
        b = ~Pb207_Pb204.perc,
        c = ~Pb208_Pb204.perc,
        text = ~cluster,
        hovertext = ~lbl,
        # text = ~cluster,
        hoverinfo = 'text',
        #opacity = .3, 
        marker = list(
          # symbol = ~symbol,
          # symbols = 'square',# unique(df.isotop$symbol),
          color = ~color.object,
          size = 10,
          opacity = 0,
          line = list('width' = 1, 
                      color = '#00000070')),
        showlegend = F, 
        inherit = F
      ) %>%
      layout(
        # title = "Relative percentages of lead isotops",
        title = list(text = "Relative % of lead isotopes for mines and EIA items", x = 1),
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
        ),
        legend = list(x = 0.1, y = 0.9)
      )
    # fig
    fig$config <- list(doubleClick = "resize")
    fig
    
  })
}

shinyApp(ui, server)

