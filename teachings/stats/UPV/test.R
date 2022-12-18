library(ggplot2)
library(archdata)
data("OxfordPots")

OxfordPots$OxfordPct.log <- log(OxfordPots$OxfordPct)
Oxford.water <- subset(OxfordPots, WaterTrans == 1)
lm.water <- lm(OxfordPct ~ OxfordDst, data = Oxford.water)
r2 <- round(summary(lm.water)$r.squared, 2)
Oxford.water$predicted <- predict(lm.water) 
Oxford.water$residuals <- residuals(lm.water)
values <- paste0(Oxford.water$Place, "<br>", Oxford.water$OxfordPct)
residuals <- paste0(Oxford.water$Place, "<br>", round(Oxford.water$predicted, 2))
m <- list(
  l = 50,
  r = 50,
  b = 100,
  t = 50,
  pad = 20
)
oxford.water <- Oxford.water %>% 
  plot_ly(x = ~OxfordDst) %>% 
  add_trace(name = "Oxford Pottery", y = ~OxfordPct,
            #mode = 'scatter',
            marker = list(color = 'black'), 
            text = values,
            hoverinfo = 'text') %>%
  add_trace(name = "Predicted value", y = ~predicted, opacity = 0.5,
            #mode = 'scatter',
            marker = list(color = 'grey', line = list(color = 'grey', width = 1)),
            text = residuals,
            hoverinfo = 'text') %>% 
  add_trace(name = "Regression line", x = ~OxfordDst, y = fitted(lm.water),
            mode = 'lines', line = list(color = 'black', width = 2),
            text = r2,
            hoverinfo = 'text') %>%
  add_segments(name = "Residuals",  x = ~OxfordDst, y =  ~OxfordPct,
               xend = ~OxfordDst, yend = ~predicted, 
               mode = 'lines', 
               line = list(color = 'grey', width = 1, dash = 'dash'),
               text = ~residuals,
               hoverinfo = 'text') %>%
  layout(title = paste0('Oxford pottery with a probable water transportation <br> (R<sup>2</sup> = ', r2, ")"),
         xaxis = list(title = "Distance (miles)"), 
         yaxis = list(title = "Percentage of Oxford Pottery"),
         margin = m,
         legend = list(orientation = "h",   
                       xanchor = "center",  
                       y = - 0.1,
                       x = 0.5)) 
htmlwidgets::saveWidget(oxford.water, "C:/Rprojects/thomashuet/teachings/stats/_stats/dim2/oxfordwater.html")