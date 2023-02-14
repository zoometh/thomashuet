# Teaching app
# data with 2 dimensions spatial


library(shiny)
library(leaflet)
library(leaflet.minicharts)
library(plotly)
library(archdata)
library(dplyr)
library(DT)
library(reshape)

data(OxfordPots)
# rectify an error in the dataset
OxfordPots[OxfordPots$Place == "Gatcombe", "NewForestPct"] <- 0

## New Forest vs Oxford
finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]
finePots$labels <- paste0(" ", rownames(finePots), ". ", finePots$Place)
finePots <- finePots[ , c("Place", "labels", "OxfordPct", "NewForestPct")]

## by transport
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


Place.coords.path <- "C:/Rprojects/thomashuet/teachings/stats/stats/dim2/oxfordpots_data.xlsx"
Place.coords <- openxlsx::read.xlsx(Place.coords.path, 1)
Place.coords <- Place.coords[ , c("Place", "lon", "lat")]
Place.coords[, c("lon", "lat")] <- sapply(Place.coords[, c("lon", "lat")], as.numeric)

finePots <- merge(finePots, Place.coords, by = "Place")
df.both <- merge(OxfordPots, Place.coords, by = "Place")
df.nowater <- merge(Oxford.nowater, Place.coords, by = "Place")
df.water <- merge(Oxford.water, Place.coords, by = "Place")

colors <- c("green", "red")

ui <- fluidPage(
  br(), br(), br(), br(), br(), br(), br(), br(), br(),
  h3("Distribution of Late Romano-British Fine Ware"),
  # fluidRow(column(3, radioButtons("residuals", "show residuals",
  #                                 choices = c("Yes", "No"), selected = "No"))
  # ),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      radioButtons("pie", "Ratio",
                   choices = c("raw", "pie"), 
                   selected = "raw"),
      radioButtons("pts", "Map",
                   choices = c("raw", "pie", "water transport", "residuals"), 
                   selected = "raw")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Ratio", 
                 plotlyOutput('ratioPlot', width = 1000, height = 600)),
        tabPanel("Map", 
                 leafletOutput("mymap", width = 800, height = 600)),
        tabPanel("Data", 
                 DT::dataTableOutput(outputId = "dataframePlot")),
        tabPanel("Source", 
                 uiOutput("sources"))
      )
    )
  )#,
  # HTML("Sources:<br>
  # Hodder, I. 1974. A Regression Analysis of Some Trade and Marketing Patterns. World Archaeology 6: 172-189.<br>
  # Hodder, I. and C. Orton. 1976. Spatial Analysis in Archaeology, pp 117-119.
  #    ")
)

server <- function(input, output, session) {
  output$sources <- renderUI({HTML(
("Hodder, I. 1974. A Regression Analysis of Some Trade and Marketing Patterns. World Archaeology 6: 172-189.<br>Hodder, I. and C. Orton. 1976. Spatial Analysis in Archaeology, pp 117-119.
     "))
  })
  output$ratioPlot <- renderPlotly({
    if(input$pie == "raw"){
      finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]
      labels <- paste0(" ", rownames(finePots), ". ", finePots$Place)
      t <- list(
        family = "sans serif",
        size = 14,
        color = "blue")
      xy.size <- 6
      
      OxfordP <- "C:/Rprojects/thomashuet/teachings/stats/UPV/images/art-pottery-oxford.jpg"
      NewForP <- "C:/Rprojects/thomashuet/teachings/stats/UPV/images/art-pottery-newforest.jpg"
      OxfordP.txt <- RCurl::base64Encode(readBin(OxfordP, "raw", file.info(OxfordP)[1, "size"]), "txt")
      NewForP.txt <- RCurl::base64Encode(readBin(NewForP, "raw", file.info(NewForP)[1, "size"]), "txt")
      
      m <- list(
        l = 50,
        r = 50,
        b = 100,
        t = 50,
        pad = 20
      )
      
      fig <- plot_ly(finePots, x = ~OxfordPct, y = ~NewForestPct, text = labels,
                     type = 'scatter', mode = 'markers') %>%
        add_text(textfont = t, textposition = 'middle right') %>%
        layout(title = paste0('Ratio Oxford pottery/New Forest pottery for ', nrow(finePots),
                              ' Late Roman sites'),
               xaxis = list(title = "% Oxford pottery", showgrid = FALSE),
               yaxis = list(title = "% New Forest pottery", showgrid = FALSE),
               margin = m,
               images = list(
                 list(
                   source =  paste('data:image/jpg;base64', NewForP.txt, sep=','),
                   xref = "x",
                   yref = "y",
                   x = 15,
                   y = 18,
                   sizex = xy.size,
                   sizey = xy.size,
                   # sizing = "stretch",
                   opacity = 1,
                   layer = "below"
                 ),
                 list(
                   source =  paste('data:image/jpg;base64', OxfordP.txt, sep=','),
                   xref = "x",
                   yref = "y",
                   x = 18,
                   y = 9,
                   sizex = xy.size,
                   sizey = xy.size,
                   # sizing = "stretch",
                   opacity = 1,
                   layer = "below"
                 )
               )
        )
      # fig
      # print("dedede")
    }
    else if(input$pie == "pie"){
      fig <- plot_ly()
      finePots <- OxfordPots[!is.na(OxfordPots$OxfordPct) & !is.na(OxfordPots$NewForestPct), ]
      labels <- paste0(" ", rownames(finePots), ". ", finePots$Place)
      finePots <- finePots[ , c("Place", "OxfordPct", "NewForestPct")]
      ws.melt <- melt(finePots)
      ct <- 0
      for(a.place in unique(ws.melt$Place)){
        # a.place <- "Dorchester (Dorset)"
        df <- ws.melt[ws.melt$Place == a.place, ]
        labels <- paste0(rownames(finePots[finePots$Place == a.place, ]), ". ", a.place)
        fig <- fig %>% add_pie(data = df, labels = ~variable, values = ~value,
                               name = labels, domain = list(row = ct, column = 0))
        ct <- ct + 1
      }
      fig <- fig %>% layout(title = "Ratios", showlegend = F,
                            grid=list(rows=ct, columns=1),
                            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    }
    fig
  })
  output$mymap <- renderLeaflet({
    finePots$labels.full <- paste0("<b>", finePots$label, "</b><br>",
                                   "Oxford %: ", finePots$OxfordPct, "<br>",
                                   "New Forest %: ", finePots$NewForestPct)
    map <- leaflet(Place.coords) %>%
      addProviderTiles(providers$"OpenStreetMap", group = "OSM") %>%
      addProviderTiles(providers$"Esri.WorldImagery", group = "Ortho") %>%
      addGraticule(interval = 1)
    if("raw" %in% input$pts){
      map <- map %>%
        addCircleMarkers(data = finePots,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 1,
                         radius = 4,
                         popup = ~labels.full,
                         color = "blue",
                         fillOpacity = 1,
                         opacity = 1) %>%
        addLabelOnlyMarkers(data = finePots,
                            lng = ~lon, 
                            lat = ~lat,
                            label =  ~labels, 
                            labelOptions = labelOptions(noHide = T, 
                                                        direction = 'top',
                                                        textOnly = T,
                                                        style = list(
                                                          "color" = "black", 
                                                          "font-style" = "bold",
                                                          "font-size" = "12px"
                                                        )))
    }
    if("pie" %in% input$pts){
      # only with available data
      map <- map %>%
        addMinicharts(
          lng = finePots$lon, 
          lat = finePots$lat,
          type = "pie",
          chartdata = finePots[, c("OxfordPct", "NewForestPct")],
          colorPalette = colors) %>%
        addLabelOnlyMarkers(data = finePots,
                            lng = ~lon, 
                            lat = ~lat,
                            label =  ~labels, 
                            labelOptions = labelOptions(noHide = T, 
                                                        direction = 'top',
                                                        textOnly = T,
                                                        style = list(
                                                          "color" = "black", 
                                                          "font-style" = "bold",
                                                          "font-size" = "12px"
                                                        )))
      # addMinicharts(
      #   lng = finePots$lon, 
      #   lat = finePots$lat,
      #   type = "pie",
      #   chartdata = finePots[, c("OxfordPct", "NewForestPct")],
      #   colorPalette = colors
      # )
    }
    if("water transport" %in% input$pts){
      map <- map %>%
        addCircleMarkers(data = df.water,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 1,
                         radius = 4,
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 1,
                         opacity = 1) %>%
        addCircleMarkers(data = df.nowater,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 2,
                         radius = 4,
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 0,
                         stroke = TRUE,
                         opacity = 1) 
    }
    if("residuals" %in% input$pts){
      map <- map %>%
        addCircleMarkers(data = df.water,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 1,
                         radius = ~abs(residuals),
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 1,
                         opacity = 1) %>%
        addCircleMarkers(data = df.nowater,
                         lng = ~lon,
                         lat = ~lat,
                         weight = 2,
                         radius = ~abs(residuals),
                         popup = ~Place,
                         color = "black",
                         fillOpacity = 0,
                         stroke = TRUE,
                         opacity = 1) 
    }
    map %>%
      addLayersControl(
        baseGroups = c("OSM", "Ortho"),
        position = "topright") %>%
      addScaleBar(position = "bottomright")
  })
  output$dataframePlot <- DT::renderDataTable({
    datatable(df.both)
  })
}

shinyApp(ui, server)


