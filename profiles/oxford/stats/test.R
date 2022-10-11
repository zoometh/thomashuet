d <- mtcars
fit <- lm(mpg ~ hp, data = d)

# no water
Oxford.nowater <- subset(OxfordPots, WaterTrans == 0)
lm.nowater <- lm(OxfordPct ~ OxfordDst, data = Oxford.nowater)
Oxford.nowater$predicted <- predict(lm.nowater)   # Save the predicted values
Oxford.nowater$residuals <- residuals(lm.nowater) # Save the residual values


d$predicted <- predict(fit)   # Save the predicted values
d$residuals <- residuals(fit) # Save the residual values

# Quick look at the actual, predicted, and residual values
library(dplyr)
d %>% select(mpg, predicted, residuals) %>% head()

library(ggplot2)
ggplot(d, aes(x = hp, y = mpg)) +  # Set up canvas with outcome variable on y-axis
  geom_point()  # Plot the actual points

ggplot(d, aes(x = hp, y = mpg)) +
  geom_point() +
  geom_point(aes(y = predicted), shape = 1)  # Add the predicted value

ggplot(d, aes(x = hp, y = mpg)) +
  geom_segment(aes(xend = hp, yend = predicted)) +
  geom_point() +
  geom_point(aes(y = predicted), shape = 1)

library(ggplot2)
ggplot(Oxford.water, aes(OxfordDst, OxfordPct)) +
  geom_smooth(method='lm', se = F, color = "black") +
  geom_segment(aes(xend = OxfordDst, yend = predicted), alpha = .2) +  # alpha to fade lines
  geom_point() +
  geom_point(aes(y = predicted), shape = 4) +
  # scale_y_continuous(breaks = c(1, 5, 10, 20), trans = 'log') +
  theme_bw()  # Add theme for cleaner look


library(reshape2) # to load tips data
library(tidyverse)
# library(tidymodels) # for the fit() function
library(plotly)
library(dplyr)
data(tips)

y <- Oxford.water$OxfordPct
X <- Oxford.water$OxfordDst

lm_model <- lm(OxfordPct ~ OxfordDst, data = Oxford.water) 

x_range <- seq(min(X), max(X), length.out = 100)
x_range <- matrix(x_range, nrow=100, ncol=1)
xdf <- data.frame(x_range)
colnames(xdf) <- c('total_bill')

ydf <- lm_model %>% predict(xdf) 

colnames(ydf) <- c('tip')
xy <- data.frame(xdf, ydf) 

fig <- plot_ly(tips, x = ~total_bill, y = ~tip, type = 'scatter', alpha = 0.65, mode = 'markers', name = 'Tips')
fig <- fig %>% add_trace(data = xy, x = ~total_bill, y = ~tip, name = 'Regression Fit', mode = 'lines', alpha = 1)
fig