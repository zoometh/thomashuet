library(spatstat)

x1 <- seq(1:10)
w <- as.owin(c(min(x1), max(x1),
               min(x1), max(x1)))
plot(w, lwd=3, main = "")
pts <- runifpoint(5, win = w)
plot(pts)

ch <- convexhull(pts)
plot(ch, add = TRUE)

ctr <- centroid.owin(pts, as.ppp = FALSE)
points(mean(pts$x), mean(pts$y), pch = 16)

segments(x0 = pts$x[-length(pts$x)], 
         y0 = pts$y[-length(pts$y)], 
         x1 = pts$x[-1], 
         y1 = pts$y[-1],
         col = "darkgreen")

plot(boundingcircle(pts), add = TRUE)


X <- psp(runif(5), runif(5), runif(5), runif(5), window=w)
m <- data.frame(A=1:5, B=letters[1:5])
X <- psp(runif(5, min = 0, max = 10),
         runif(5, min = 0, max = 10),
         runif(5, min = 0, max = 10),
         runif(5, min = 0, max = 10), window=w, marks=m)


d <-data.frame(x0 = pts$x[-length(pts$x)], 
               y0 = pts$y[-length(pts$y)], 
               x1 = pts$x[-1], 
               y1 = pts$y[-1])
d$xmean <- rowMeans(cbind(d$x0, d$x1))
d$ymean <- rowMeans(cbind(d$y0, d$y1))
points(d$xmean, 
       d$ymean,
       pch = 16,
       col = "darkgreen")
