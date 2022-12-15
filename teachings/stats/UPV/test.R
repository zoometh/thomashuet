library(DT)
library(dplyr)
df <- data.frame(feat = c("A", "B", "C"),
                 where = c(20, 60, 60),
                 when = c(10, 30, 20),
                 what = c(70, 10, 20),
                 row.names = c("A", "B", "C"))
datatable(df) %>%
  formatStyle(columns = "where",
              rows = c(1),
              target = "row" , 
              background = c("red"))

sites <- rownames(df)
df

library(DT)
datatable(iris) %>% 
  formatStyle(.,
              columns = c(1,2),
              valueColumns = c(0, 1),
              target = 'cell',
              backgroundColor = styleEqual(3, 'red')
  )

v1 <- row.names(df)
A <- ifelse(v1 =='A','red','')
B <- ifelse(v1 =='B','green','')

datatable(df, rownames = FALSE) %>% 
  formatStyle(
    "feat",
    backgroundColor = styleEqual(c("A", "B", "C"), c('red', 'green', 'blue'))
  )
  
  
  
  formatStyle(0, 
              target = "row",
              backgroundColor = c(styleEqual(v1, A), styleEqual(v1, B))) %>% 
  formatStyle(0, 
              target = "row",
              backgroundColor = styleEqual(v1, B))

