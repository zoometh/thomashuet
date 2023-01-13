# Teaching app
# data with 2 dimensions

library(plotly)
library(archdata)

data(OxfordPots)

finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("Distribution of Late Romano-British Oxford Pottery"),
  fluidRow(column(3, checkboxGroupInput("watertrans", "water transportation probable",
                                        choices = c("Yes", "No"), selected = c("Yes", "No"))),
           column(3, radioButtons("regression", "show regression",
                                  choices = c("Yes", "No"), selected = "No"))
  ),
  # radioButtons("residuals", "show residuals",
  #              choices = c("Yes", "No"), selected = "No"
  # ),
  plotlyOutput("graph", 
               height = "500px"),
  HTML("Sources:<br>
  Hodder, I. 1974. A Regression Analysis of Some Trade and Marketing Patterns. World Archaeology 6: 172-189.<br>
  Hodder, I. and C. Orton. 1976. Spatial Analysis in Archaeology, pp 117-119.
     ")
)

server <- function(input, output, session){
  # water
  OxfordPots$OxfordPct.log <- log(OxfordPots$OxfordPct)
  Oxford.water <- subset(OxfordPots, WaterTrans == 1)
  Oxford.lm.water <- lm(log(OxfordPct)~OxfordDst, Oxford.water)
  lm.water <- lm(OxfordPct ~ OxfordDst, data = Oxford.water)
  # lm.water.R2 <- round(summary(lm.water)$r.squared, 2)
  r2.water <- round(summary(lm.water)$r.squared, 2)
  Oxford.water$predicted <- predict(lm.water)   # Save the predicted values
  Oxford.water$residuals <- residuals(lm.water) # Save the residual values
  water.values <- paste0("<b>", Oxford.water$Place, "</b><br>", 
                         "Observed: ", Oxford.water$OxfordPct)
  water.residuals <- paste0("<b>", Oxford.water$Place, "</b><br>",
                            "Observed: ", round(Oxford.water$predicted, 2))
  
  # no water
  Oxford.nowater <- subset(OxfordPots, WaterTrans == 0)
  Oxford.lm.nowater <- lm(log(OxfordPct)~OxfordDst, Oxford.nowater)
  lm.nowater <- lm(OxfordPct ~ OxfordDst, data = Oxford.nowater)
  r2.nowater <- round(summary(lm.nowater)$r.squared, 2)
  # lm.nowater.R2 <- round(summary(lm.nowater)$r.squared, 2)
  Oxford.nowater$predicted <- predict(lm.nowater)   # Save the predicted values
  Oxford.nowater$residuals <- residuals(lm.nowater) # Save the residual values
  nowater.values <- paste0("<b>", Oxford.nowater$Place, "</b><br>", 
                           "Observed: ", Oxford.nowater$OxfordPct)
  nowater.residuals <- paste0("<b>", Oxford.nowater$Place, "</b><br>",
                              "Observed: ", round(Oxford.nowater$predicted, 2))
  # 
  # Oxford.nowater$predicted <- predict(Oxford.lm.nowater)   # Save the predicted values
  # Oxford.nowater$residuals <- residuals(Oxford.lm.nowater) # Save the residual values
  
  # d <- mtcars
  # fit <- lm(mpg ~ hp, data = d)
  m <- list(
    l = 50,
    r = 50,
    b = 100,
    t = 50,
    pad = 20
  )
  
  output$graph <- renderPlotly({
    # water transport
    if("Yes" %in% input$watertrans & !("No" %in% input$watertrans)){
      ox.w <- Oxford.water %>% 
        plot_ly(x = ~OxfordDst, width = 1200, height = 700) %>% 
        add_trace(name = "Oxford Pottery", y = ~OxfordPct,
                  marker = list(color = 'black'), 
                  text = water.values,
                  hoverinfo = 'text')
      if("Yes" %in% input$regression){
        ox.w <- ox.w %>% 
          add_trace(name = "Regression line", x = ~OxfordDst, y = fitted(lm.water),
                    mode = 'lines', line = list(color = 'darkgrey', width = 1.5),
                    # text = r2.water,
                    text = ~paste0("R<sup>2</sup>: ", round(r2.water, 2)),
                    hoverinfo = 'text') %>%
          add_segments(name = "Residuals",  x = ~OxfordDst, y =  ~OxfordPct,
                       xend = ~OxfordDst, yend = ~predicted, 
                       mode = 'lines', 
                       line = list(color = 'lightgrey', width = 1, dash = 'dash'),
                       text = ~paste0("Residual: ", round(residuals, 1)),
                       # text = ~residuals,
                       hoverinfo = 'text') %>%
          add_trace(name = "Predicted value", y = ~predicted, opacity = 0.5,
                    marker = list(color = 'grey', line = list(color = 'grey', width = 1)),
                    # text = ~predicted,
                    text = ~paste0("Predicted: ", round(predicted, 1)),
                    hoverinfo = 'text')
      }
      
      ox.w %>%
        layout(title = paste0('Oxford pottery with a probable <b>water</b> transportation <br> (R<sup>2</sup> = ', r2.water, ")"),
               xaxis = list(title = "Distance (miles)"), 
               yaxis = list(title = "Percentage of Oxford Pottery"),
               margin = m,
               legend = list(orientation = "h",   
                             xanchor = "center",  
                             y = + 0.1,
                             x = 0.5)) 
      }
    
    # no water transport
    else if("No" %in% input$watertrans & !("Yes" %in% input$watertrans)){
      
      ox.nw <- Oxford.nowater %>% 
        plot_ly(x = ~OxfordDst, width = 1200, height = 700) %>% 
        add_trace(name = "site with Oxford pottery water transport", y = ~OxfordPct,
                  marker = list(color = 'rgba(0, 0, 0, 0)',
                                line = list(
                                  color = 'black',
                                  width = 1.5
                                )), 
                  text = nowater.values,
                  hoverinfo = 'text')
      if("Yes" %in% input$regression){
        ox.nw <- ox.nw %>% 
          add_trace(name = "Predicted value", y = ~predicted, opacity = 0.5,
                    #mode = 'scatter',
                    marker = list(color = 'grey', line = list(color = 'grey', width = 1)),
                    # text = ~predicted,
                    text = ~paste0("Predicted: ", round(predicted, 1)),
                    hoverinfo = 'text') %>% 
          add_trace(name = "Regression line", x = ~OxfordDst, y = fitted(lm.nowater),
                    mode = 'lines', line = list(color = 'darkgrey', width = 1.5),
                    # text = r2.nowater,
                    text = ~paste0("R<sup>2</sup>: ", round(r2.nowater, 2)),
                    hoverinfo = 'text') %>%
          add_segments(name = "Residuals",  x = ~OxfordDst, y =  ~OxfordPct,
                       xend = ~OxfordDst, yend = ~predicted, 
                       mode = 'lines', 
                       line = list(color = 'lightgrey', width = 1, dash = 'dash'),
                       # text = ~residuals,
                       text = ~paste0("Residual: ", round(residuals, 1)),
                       hoverinfo = 'text')
      }
      ox.nw %>%
        layout(title = paste0('Oxford pottery with a probable <b>no water</b> transportation <br> (R<sup>2</sup> = ', r2.nowater, ")"),
               xaxis = list(title = "Distance (miles)"), 
               yaxis = list(title = "Percentage of Oxford Pottery"),
               margin = m,
               legend = list(orientation = "h",   
                             xanchor = "center",  
                             y = + 0.05,
                             x = 0.5)) 
    }
    
    # both: water and no water
    else if("No" %in% input$watertrans & "Yes" %in% input$watertrans){
      ox.A <- plot_ly(width = 1200, height = 700) %>% 
        add_trace(data = Oxford.water, x = ~OxfordDst, 
                  name = "water transport", y = ~OxfordPct,
                  marker = list(color = 'black'), 
                  text = water.values,
                  hoverinfo = 'text') %>%
        add_trace(data = Oxford.nowater, x = ~OxfordDst, 
                  name = "no water transport", y = ~OxfordPct,
                  #mode = 'scatter',
                  marker = list(color = 'rgba(0, 0, 0, 0)',
                                line = list(
                                  color = 'black',
                                  width = 1.5
                                )), 
                  text = nowater.values,
                  hoverinfo = 'text')
      if("Yes" %in% input$regression){
        ox.A <- ox.A %>%
          # water
          add_trace(data = Oxford.water, name = "Predicted value", y = ~predicted, opacity = 0.5,
                    #mode = 'scatter',
                    marker = list(color = 'grey', line = list(color = 'grey', width = 1)),
                    # text = ~predicted,
                    text = ~paste0("Predicted: ", round(predicted, 1)),
                    hoverinfo = 'text') %>% 
          add_trace(data = Oxford.water, name = "Regression line", x = ~OxfordDst, y = fitted(lm.water),
                    mode = 'lines', line = list(color = 'darkgrey', width = 1.5),
                    # text = r2.water,
                    text = ~paste0("R<sup>2</sup>: ", round(r2.water, 2)),
                    hoverinfo = 'text') %>%
          add_segments(data = Oxford.water, name = "Residuals",  x = ~OxfordDst, y =  ~OxfordPct,
                       xend = ~OxfordDst, yend = ~predicted, 
                       mode = 'lines', 
                       line = list(color = 'lightgrey', width = 1, dash = 'dash'),
                       # text = ~residuals,
                       text = ~paste0("Residual: ", round(residuals, 1)),
                       hoverinfo = 'text') %>%
          # no water
          add_trace(data = Oxford.nowater, name = "Predicted value", y = ~predicted, opacity = 0.5,
                    #mode = 'scatter',
                    marker = list(color = 'grey', line = list(color = 'grey', width = 1)),
                    # text = ~predicted,
                    text = ~paste0("Predicted: ", round(predicted, 1)),
                    hoverinfo = 'text') %>% 
          add_trace(data = Oxford.nowater, name = "Regression line", x = ~OxfordDst, y = fitted(lm.water),
                    mode = 'lines', line = list(color = 'darkgrey', width = 1.5),
                    # text = r2.nowater,
                    text = ~paste0("R<sup>2</sup>: ", round(r2.nowater, 2)),
                    hoverinfo = 'text') %>%
          add_segments(data = Oxford.nowater, name = "Residuals",  x = ~OxfordDst, y =  ~OxfordPct,
                       xend = ~OxfordDst, yend = ~predicted, 
                       mode = 'lines', 
                       line = list(color = 'lightgrey', width = 1, dash = 'dash'),
                       # text = ~residuals,
                       text = ~paste0("Residual: ", round(residuals, 1)),
                       hoverinfo = 'text')
      }
      ox.A %>%
        layout(title = paste0('Oxford pottery (water and no water transport)'),
               xaxis = list(title = "Distance (miles)"), 
               yaxis = list(title = "Percentage of Oxford Pottery"),
               margin = m,
               legend = list(orientation = "h",   
                             xanchor = "center",  
                             y = + 0.05,
                             x = 0.5)) 
    }
  })
}

shinyApp(ui, server)