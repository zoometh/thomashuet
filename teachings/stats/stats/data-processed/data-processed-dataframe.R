library(DT)
library(archdata)
library(dplyr)


data("Mesolithic")
Mesolithic.pers <- round(Mesolithic/rowSums(Mesolithic)*100, 1)
rownames(Mesolithic.pers) <- paste0("site_", rownames(Mesolithic.pers))
font.size <- "20pt"
Mesolithic.pers <- Mesolithic.pers %>% 
  DT::datatable(
    options=list(
      initComplete = htmlwidgets::JS(
        "function(settings, json) {",
        paste0("$(this.api().table().container()).css({'font-size': '", font.size, "'});"),
        "}")
    ) 
  ) %>%
  formatStyle(
    colnames(Mesolithic.pers),
    background = styleColorBar(Mesolithic.pers$Microliths, 'lightblue'),
    backgroundSize = '100% 90%',
    backgroundRepeat = 'no-repeat',
    backgroundPosition = 'center'
  )
Mesolithic.pers
htmlwidgets::saveWidget(Mesolithic.pers, "C:/Rprojects/thomashuet/teachings/stats/stats/data-processed/data-processed.html")

