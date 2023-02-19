# normal distribution

library(ggplot2)

ui <- fluidPage(
  # sliderInput("mean",
  #             label = "mean",
  #             min = -2, value = 0, max = +2),
  sliderInput("sd",
              label = "standard deviation",
              min = .5, value = 2, max = 5),
  # checkboxGroupInput("m", 
  #                    "show", 
  #                    c("mean", "median"), selected = "mean"),
  plotOutput("graph")
)

server <- function(input, output) {
  output$graph <- renderPlot({
    set.seed(1)
    x <- seq(-5, 5, length = 1000)
    y <- rnorm(x, mean = 0, sd = input$sd)
    normConfInt <- function(x, alpha = 0.05)
      mean(x) + qt(1 - alpha / 2, length(x) - 1) * sd(x) / sqrt(length(x)) * c(-1, 1)
    
    # # Use quantile function to compute the confidence interval (CI)
    # lo <- qnorm(alpha/2,   mean=mu, sd=sd)  # lower CI bound
    # hi <- qnorm(1-alpha/2, mean=mu, sd=sd)  # upper CI bound
    # 
    # # start with an empty plot
    # plot(NULL,NULL, type='n', xlim=range(x), ylim=range(y),
    #      xlab=NA, ylab="Probability density", las=1)
    # 
    # xci <- seq(lo, hi, len=100)             # background: confidence interval
    # yci <- dnorm(xci, mean=mu, sd=sd)
    # xx <- c(xci, rev(xci))
    # yy <- c(0*yci, rev(yci))
    # polygon(xx,yy,col=gray(0.9), border=NA)
    
    # y <- runif(1000, -5, 5)
    # df <- data.frame(PF = 10*rnorm(1000))
    df <- data.frame(PF = y)
    gplot <- ggplot(df, aes(x = PF)) + 
      geom_histogram(aes(y =..density..),
                     breaks = seq(-5, 5), 
                     colour = "black", 
                     fill = "white") +
      stat_function(fun = dnorm, 
                    args = list(mean = mean(df$PF),
                                sd = sd(df$PF))) +
      geom_vline(xintercept = mean(df$PF), color = "red", size = 2) +
      # geom_vline(xintercept = normConfInt(y)[1], color = "blue", size = 1) +
      # geom_vline(xintercept = normConfInt(y)[2], color = "blue", size = 1) +
      scale_x_continuous(breaks = seq(-5, 5, 1)) +
      theme_bw()
    



    # y <- rnorm(x, mean = 0, sd = .4)
    # gplot <- ggplot() +
    #   geom_histogram(aes(y), binwidth = 0.01) +
    #   geom_line(aes(x, y), color = "black") +
    #   ylim(0, 1) +
    #   theme_bw()
    # gplot
    # if("mean" %in% input$m){
    #   mean.x <- mean(y)
    #   gplot <- gplot +
    #     geom_vline(xintercept = mean.x, color = "red", size = 2)
    # }
    # if("median" %in% input$m){
    #   median.x <- median(y)
    #   gplot <- gplot +
    #     geom_vline(xintercept = median.x, color = "blue", size = 1.5)
    # }
    print(gplot)
  })
}

shinyApp(ui, server)
