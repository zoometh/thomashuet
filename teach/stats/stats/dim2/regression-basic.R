## Reproduce the linear regression of Oxford potteries by Fulford and Hodder (1974)
## see: https://github.com/zoometh/thomashuet/tree/main/teach/stats/upv#pratique
## see: http://shinyserver.cfs.unipi.it:3838/teach/stats/upv3/_site/#/dim-data-1

# install.packages(archdata)

library(archdata)

data("OxfordPots")

OxfordPots$OxfordPct.log <- log(OxfordPots$OxfordPct)
Oxford.water.transport <- subset(OxfordPots, WaterTrans == 1)
Oxford.water.transport.no <- subset(OxfordPots, WaterTrans == 0)
plot(x = Oxford.water.transport$OxfordDst,
     y = Oxford.water.transport$OxfordPct.log,
     xlim = c(0, max(Oxford.water.transport$OxfordDst)),
     ylim = c(0, max(Oxford.water.transport$OxfordPct.log)),
     pch = 16,
     xlab = "Distance from Oxford kilns (miles)", 
     ylab = "Percentage of Oxford pottery (Logarithmic scale)")
points(x = Oxford.water.transport.no$OxfordDst,
       y = Oxford.water.transport.no$OxfordPct.log)
abline(lm(OxfordPct.log ~ OxfordDst, data = Oxford.water.transport))
abline(lm(OxfordPct.log ~ OxfordDst, data = Oxford.water.transport.no))

# see save plot: https://stackoverflow.com/questions/7144118/how-to-save-a-plot-as-image-on-the-disk