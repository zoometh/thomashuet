
## Orientation des CRVN
# cf: https://r-graph-gallery.com/web-circular-barplot-with-R-and-ggplot2.html
geojson.path <- "C:/Users/Thomas Huet/Documents/R/win-library/4.1/eamenaR/extdata/caravanserail.geojson"
ea.geojson <- geojsonsf::geojson_sf(geojson.path)
orientations <- c("North", "North-East", "East", 
                  "South-East", "South",
                  "South-West", "West",
                  "North-West"
)
orientations <- c("North", "North-East", "East", 
                  "South-East", "South",
                  "South-West", "West",
                  "North-West"
)
orientations <- c("North", "Northeast", "East", 
                  "Southeast", "South",
                  "Southwest", "West",
                  "Northwest"
)


field.names = c("Resource Orientation")

hp.orient <- ea.geojson[ , c("EAMENA ID", field.names)]
hp.orient[["Direction"]] <- NA
for(i in seq(1, nrow(hp.orient))){
  hp.orient[i, "Direction"] <- unlist(str_split(hp.orient[i, "Resource Orientation"], "-"))[1]
}
directions <- hp.orient$Direction
directions.t <- as.data.frame(table(hp.orient$Direction))
names(directions.t) <- c("direction", "n")


df <- data.frame(direction = orientations)
# join on direction
df <- plyr::join(df, directions.t)
df[is.na(df)] <- 0
max.sum <- max(df$n)
df$direction <- factor(df$direction, levels = df$direction, ordered = T)
# reorder on levels
vvv <- reorder(str_wrap(df$direction, 5), df$n)
levels(vvv) <- df$direction


ggplot(df) +
  geom_hline(
    aes(yintercept = y),
    data.frame(y = seq(0, max.sum, by = 10)),
    color = "lightgrey"
  ) +
  geom_col(
    aes(
      x = vvv,
      # x = reorder(str_wrap(direction, 5), n),
      y = n,
      fill = n
    ),
    position = "dodge2",
    show.legend = TRUE,
    alpha = .9
  ) +
  # Lollipop shaft for mean gain per region
  geom_segment(
    aes(
      x = vvv,
      # x = reorder(str_wrap(direction, 5), n),
      y = 0,
      xend = vvv,
      # xend = reorder(str_wrap(direction, 5), n),
      yend = max.sum
    ),
    linetype = "dashed",
    color = "gray12"
  ) + 
  # to align North up
  coord_polar(start = -.4)


hp.orient[["Ressource Orientation 1"]] <- unlist(str_split(hp.orient[, "Resource Orientation"], "-"))
# orient <- orient[orient[[field.names]] %in% orientations, ]

#########################################

library(archdata)
library(fmsb)
library(arules)

data(EWBurials)

# Library

# Create data: note in High school for Jonathan:
data <- as.data.frame(matrix( sample( 2:20 , 10 , replace=T) , ncol=10))
colnames(data) <- c("math" , "english" , "biology" , "music" , "R-coding", "data-viz" , "french" , "physic", "statistic", "sport" )
df.n <- rbind(rep(20,10) , rep(0,10) , data)
radarchart(data)

df <- as.data.frame(t(as.data.frame(table(EWBurials$Direction))))
missing.dir <- setdiff(1:360, as.numeric(df[1,]))
colnames(df) <- df[1,]
df <- df[2,]
df <- cbind(df,  setNames(rep(list(0), length(missing.dir)), missing.dir))
col.ord <- as.character(1:360)
df <- df[ , col.ord] # reorder
vals <- as.numeric(df[1, ])

# discretize(vals, method = "interval", breaks = c(36), labels =)

dataa <- as.data.frame(matrix(vals, ncol = 360))
dataa <- rbind(rep(max(vals), ncol(df)),
               rep(0, ncol(df)),
               dataa)
radarchart(dataa, axistype = 0)

library(stringr)
library(dplyr)
library(ggplot2)

hike_data <- readr::read_rds("C:/Users/Thomas Huet/Downloads/hike_data.rds")
hike_data$region <- as.factor(word(hike_data$location, 1, sep = " -- "))
hike_data$length_num <- as.numeric(sapply(strsplit(hike_data$length, " "), "[[", 1))

plot_df <- hike_data %>%
  group_by(region) %>%
  summarise(
    sum_length = sum(length_num),
    mean_gain = mean(as.numeric(gain)),
    n = n()
  ) %>%
  mutate(mean_gain = round(mean_gain, digits = 0))

ggplot(plot_df) +
  # Make custom panel grid
  geom_hline(
    aes(yintercept = y), 
    data.frame(y = c(0:3) * 1000),
    color = "lightgrey"
  ) + 
  # Add bars to represent the cumulative track lengths
  # str_wrap(region, 5) wraps the text so each line has at most 5 characters
  # (but it doesn't break long words!)
  geom_col(
    aes(
      x = reorder(str_wrap(region, 5), sum_length),
      y = sum_length,
      fill = n
    ),
    position = "dodge2",
    show.legend = TRUE,
    alpha = .9
  ) +
  
  # Add dots to represent the mean gain
  geom_point(
    aes(
      x = reorder(str_wrap(region, 5),sum_length),
      y = mean_gain
    ),
    size = 3,
    color = "gray12"
  ) +
  
  # Lollipop shaft for mean gain per region
  geom_segment(
    aes(
      x = reorder(str_wrap(region, 5), sum_length),
      y = 0,
      xend = reorder(str_wrap(region, 5), sum_length),
      yend = 3000
    ),
    linetype = "dashed",
    color = "gray12"
  ) + 
  
  # Make it circular!
  coord_polar()


################################


# ggplot(plot_df) +
ggplot(ddd) +
  # Make custom panel grid
  # geom_hline(
  #   aes(yintercept = y), 
  #   data.frame(y = c(0:max(vals))),
  #   color = "lightgrey"
  # ) + 
  # Add bars to represent the cumulative track lengths
  # str_wrap(region, 5) wraps the text so each line has at most 5 characters
  # (but it doesn't break long words!)
  geom_col(
    aes(
      x = reorder(str_wrap(region, 5), sum_length),
      y = sum_length#,
      # fill = n
    ),
    position = "dodge2",
    show.legend = TRUE,
    alpha = .9
  ) +
  
  
  # Lollipop shaft for mean gain per region
  geom_segment(
    aes(
      x = reorder(str_wrap(region, 5), sum_length),
      y = 0,
      xend = reorder(str_wrap(region, 5), sum_length),
      yend = max(vals)
    ),
    linetype = "dashed",
    color = "gray12"
  ) + 
  
  # Make it circular!
  coord_polar()



