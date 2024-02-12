library(rvest)
library(wordcloud)
library(tm)
library(tibble)


research.soa <- function(soa.url = NA, soa.research.areas = NA, soa.stopwords = c("oxford", "school", "archaeolog", "research", "study", "seminar", "discussion", "projects", "periods", "forum", "collaborations", "well", "provid", "listed", "many", "including")){
  for(research.area in soa.research.areas){
    # research.area <- 'historical-and-classical'
    url <- paste0(soa.url, research.area)
    html_content <- read_html(url)
    paragraphs <- html_nodes(html_content, "p")
    website_text <- html_text(paragraphs, trim = TRUE)
    corp <- Corpus(VectorSource(website_text))
    corp <- tm_map(corp, stemDocument)
    corp <- tm_map(corp, removePunctuation)
    corp <- tm_map(corp, content_transformer(tolower))
    corp <- tm_map(corp, removeWords, stopwords("english"))
    corp <- tm_map(corp, stripWhitespace)
    corp <- tm_map(corp, removeWords, soa.stopwords)
    tdm <- TermDocumentMatrix(corp)
    matrix <- as.matrix(tdm)
    words <- sort(rowSums(matrix), decreasing=TRUE)
    df <- data.frame(word = names(words), freq=words)
    set.seed(1234)
    outWC <- paste0("C:/Rprojects/Rdev/text/img/", research.area, ".png")
    png(outWC, width = 900, height = 900, res = 150)
    wordcloud(words = df$word, freq = df$freq,
              min.freq = 1, max.words = 50,
              random.order = FALSE, rot.per = 0.2,
              colors=brewer.pal(8, "Dark2"))
    dev.off()
    print(paste("Exported:", research.area))
  }
}

# devtools::source_url("https://raw.githubusercontent.com/zoometh/Rdev/master/text/soa_cloudword_1.R")
#
# soa.url <- 'https://www.arch.ox.ac.uk/'
# soa.research.areas <- list('bioarchaeology', 'chronology', 'eurasian-prehistory', 'historical-and-classical', 'materials-and-technology', 'palaeolithic')
# research.soa(soa.url, soa.research.areas)

