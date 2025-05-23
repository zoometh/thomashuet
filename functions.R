library(kableExtra)
library(dplyr)
library(knitr)
library(magick)
library(leaflet)
library(RPostgreSQL)
library(rdrop2)

GHimgs <- "https://github.com/zoometh/C14/tree/main/docs/imgs/"

# setwd("F:\\Perso")

token <- readRDS("droptoken.rds")
drop_acc(dtoken = token)
drop_dir()

f.bego.plan <- function(roches.xy){
  # load plan from GDropBox
  plan.path <- "D:\\\\Base de Donnees"
  # \\\\Images\\\\Images Faces\\\\
  roches.xy$Plan <- gsub(plan.path,"Bego",roches.xy[,"Plan"])
  roches.xy$Plan <- gsub("\\\\","/",roches.xy[,"Plan"])
  roches.xy$Plan_lk <- NA
  for (i in 1:nrow(roches.xy)){
    # i <- 1
    a.img <- drop_media("Bego/Images/SS_Plan.bmp")
    try(a.img <- drop_media(roches.xy[i,"Plan"]),
        silent = T)
    # a.img <- drop_media('Sauri/R11/IMG_8279.JPG')
    roches.xy[i,"Plan_lk"] <- path.img <- paste0('<img src="',
                                                 a.img$link,
                                                 # 'https://drive.google.com/uc?export=view&id=',
                                                 # a.rock.fold,
                                                 # '1DBlLa-PnN2hWcAIoqf5jhb7rIOarIM7y',
                                                 '" style="width: 55vw; max-width: 200px;" >')
  }
  return(roches.xy)
}

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,
                 dbname="bego",
                 host="localhost",
                 port=5432,
                 user="postgres",
                 password="postgres")
sqll <- "select zone,groupe,roche,nom,histoseule,geographie ,ST_X(ST_Transform(wkb_geometry, 4326)) as x ,ST_Y(ST_Transform(wkb_geometry, 4326)) as y from roches_gravees"
sqll <- paste0(sqll," where zone>0 and zone<13") # Me
roches.Me <- dbGetQuery(con,sqll)
stele.chef <- roches.Me[roches.Me$zone == 7 & roches.Me$groupe == 1 & roches.Me$roche == '8',]
stele.chef.lk <- drop_media("Bego/Images/Images Faces/ZVII/ZVIIGI/ZVIIGIR8.gif")
Plan_lk <- paste0('<img src="',
                  stele.chef.lk,
                  '" style="width: 55vw; max-width: 200px;" >')
dbDisconnect(con)
m <- leaflet() %>%
  setView(lng = stele.chef$x, lat = stele.chef$y, zoom=18) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=roches.Me$x, lat=roches.Me$y, popup="roche gravée",radius = 1,opacity = 0.3) %>%
  addCircleMarkers(lng=stele.chef$x, lat=stele.chef$y,
                   # label = ~lapply(paste0("<b>","Stèle du chef de tribu","</b> <br>",
                   #                            Plan_lk),
                   #                     htmltools::HTML),
                   # popup="Stèle du chef de tribu",
                   popup = paste0("<img src = ", Plan_lk, ">","<br>",Plan_lk),
                   # label = ~lapply(paste0("<b>",as.character("stele.chef"),"</b> <br>",
                   #                        Plan_lk),
                   # htmltools::HTML),
                   color = "red",
                   radius = 2,
                   opacity = 0.7)
m
library(htmlwidgets)
saveWidget(m, file="m.html")