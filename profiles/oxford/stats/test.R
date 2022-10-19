
dirIn <- "https://raw.githubusercontent.com/zoometh/neonet/main/inst/extdata/"
fileIn <- "140_140_id00140_doc_elencoc14.tsv"
dataIn <- paste0(dirIn, fileIn)

C14 <- read.csv2(dataIn, sep = "\t")
C14cal <- calibrate(x = C14[1, "C14Age"], 
                    errors = C14[1, "C14SD"],
                    calCurves='intcal20')

library(rcarbon)
data(emedyd)
levant <- emedyd[emedyd$Region=="1", ]
bins <- binPrep(C14[1:2, "SiteName"],
                C14[1:2, "C14Age"],
                h = 50)
x <- calibrate(C14[1:2, "C14Age"],
               C14[1:2, "C14SD"],
               normalised = FALSE)
spd.levant <- spd(x,
                  bins=bins,
                  timeRange = c(7000, 4000))
plot(spd.levant,
     runm = 50, 
     xlim = c(6500, 5000))
