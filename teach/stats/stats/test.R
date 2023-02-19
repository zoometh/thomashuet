rm(list=ls()) # Always start with a clean slate
library(rtrim)
red   <- "#E41A1C" # Set up some nice colors
blue  <- "#377EB8"
green <- "#4daf4a"
lgray <- gray(0.8)
mgray <- gray(0.5)
dgray <- gray(0.2)
mu    <- 5.0                            # mean
sd    <- 4.0                            # standard deviation
alpha <- 0.05                           # i.e., 95% confidence interval

# Full normal distribution
x <- seq(mu-3*sd, mu+3*sd, len=100)
y <- dnorm(x, mean=mu, sd=sd)

# Use quantile function to compute the confidence interval (CI)
lo <- qnorm(alpha/2,   mean=mu, sd=sd)  # lower CI bound
hi <- qnorm(1-alpha/2, mean=mu, sd=sd)  # upper CI bound

# start with an empty plot
plot(NULL,NULL, type='n', xlim=range(x), ylim=range(y),
     xlab=NA, ylab="Probability density", las=1)

xci <- seq(lo, hi, len=100)             # background: confidence interval
yci <- dnorm(xci, mean=mu, sd=sd)
xx <- c(xci, rev(xci))
yy <- c(0*yci, rev(yci))
polygon(xx,yy,col=gray(0.9), border=NA)

lines(x,y, col=red, lwd=2)              # Foreground: complete distribution

# Annotation and decoration
lines(c(mu,mu), c(0,dnorm(mu,mean=mu,sd=sd)), lty="dashed", lwd=0.5) # mean
lines(c(mu-sd,mu-sd), c(0,dnorm(mu-sd,mean=mu,sd=sd)), lty="dashed", lwd=0.5) # mu - s.d.
lines(c(mu+sd,mu+sd), c(0,dnorm(mu+sd,mean=mu,sd=sd)), lty="dashed", lwd=0.5) # mu + s.d.
abline(h=0, lwd=0.5) # proper y=0 line
text(mean(x), mean(y), sprintf("%.0f%%", 100*(1-alpha)))
yarr <- 0.02                            # y-position of arrow
arrows(mu-sd,yarr, mu,yarr, code=3,length=0.12)
text(mu-sd/2, yarr, "s.d.", pos=3)
mul <- (hi-mu) / sd                     # sd -> CI multiplier
arrows(mu,yarr, hi,yarr, code=3, length=0.12)
text(mean(c(mu,hi)), yarr, sprintf("%.2f * s.d.", mul), pos=3)
