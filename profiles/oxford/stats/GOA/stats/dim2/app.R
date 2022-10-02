# Teaching app
# data with 2 dimensions

library(plotly)
library(archdata)

data(OxfordPots)


ui <- fluidPage(
  checkboxGroupInput("watertrans", "water transportation probable",
                     choices = c("Yes", "No"), selected = "Yes"
  ),
  radioButtons("regression", "show regression",
               choices = c("Yes", "No"), selected = "No"
  ),
  plotlyOutput("graph", height = "auto")
)

server <- function(input, output, session){
  OxfordPots$OxfordPct.log <- log(OxfordPots$OxfordPct)
  Oxford.water <- subset(OxfordPots, WaterTrans==1)
  Oxford.nowater <- subset(OxfordPots, WaterTrans==0)
  Oxford.lm.water <- lm(log(OxfordPct)~OxfordDst, Oxford.water)
  Oxford.lm.nowater <- lm(log(OxfordPct)~OxfordDst, Oxford.nowater)
  output$graph <- renderPlotly({
    if("Yes" %in% input$watertrans & !("No" %in% input$watertrans)){
      gplot <- ggplot(Oxford.water, aes(OxfordDst, OxfordPct)) +
        # stat_summary(fun.data=mean_cl_normal) + 
        geom_point() +
        # geom_point(data = Oxford.nowater, aes(OxfordDst, OxfordPct)) +
        scale_y_continuous(breaks = c(1, 5, 10, 20), trans = 'log') +
        xlab("Distance (miles)") +
        ylab("Percentage of Oxford Pottery") +
        xlim(c(0, 160)) +
        theme_bw()
      if("Yes" %in% input$regression){
        gplot <- gplot +
          geom_smooth(method='lm', formula= y~x, se = F, color = "black")
      }
      print(ggplotly(gplot))
    }
    else if("No" %in% input$watertrans & !("Yes" %in% input$watertrans)){
      gplot <- ggplot(Oxford.nowater, aes(OxfordDst, OxfordPct)) +
        geom_point(shape = 1) +
        scale_y_continuous(breaks = c(1, 5, 10, 20), trans = 'log') +
        xlab("Distance (miles)") +
        ylab("Percentage of Oxford Pottery") +
        xlim(c(0, 160)) +
        theme_bw()
      if("Yes" %in% input$regression){
        gplot <- gplot +
          geom_smooth(method='lm', formula= y~x, se = F, color = "black")
      }
      print(ggplotly(gplot))
    }
    else if("No" %in% input$watertrans & "Yes" %in% input$watertrans){
      gplot <- ggplot() +
        geom_point(Oxford.nowater, mapping = aes(OxfordDst, OxfordPct), shape = 1) +
        geom_point(Oxford.water, mapping = aes(OxfordDst, OxfordPct)) +
        scale_y_continuous(breaks = c(1, 5, 10, 20), trans = 'log') +
        xlab("Distance (miles)") +
        ylab("Percentage of Oxford Pottery") +
        xlim(c(0, 160)) +
        theme_bw()
      if("Yes" %in% input$regression){
        gplot <- gplot +
          geom_smooth(data = Oxford.nowater, aes(x = OxfordDst, y = OxfordPct),
                      method='lm', formula= y~x, se = F, color = "black") +
          geom_smooth(data = Oxford.water, aes(x = OxfordDst, y = OxfordPct),
                      method='lm', formula= y~x, se = F, color = "black")
      }
      print(ggplotly(gplot))
    }
  })
}

shinyApp(ui, server)