# # Install packages if not already installed
# if (!requireNamespace("rvest", quietly = TRUE)) {
#   install.packages("rvest")
# }
#
# if (!requireNamespace("wordcloud", quietly = TRUE)) {
#   install.packages("wordcloud")
# }

# Load required libraries
library(rvest)
library(wordcloud)
library(tm)

# Function to fetch content from a website
get_website_content <- function(url) {
  page <- read_html(url)
  return(page)
}

# Function to extract text from HTML using rvest
extract_text_from_html <- function(html_content) {
  paragraphs <- html_nodes(html_content, "p")
  text <- html_text(paragraphs, trim = TRUE)
  return(paste(text, collapse = " "))
}

# Function to generate a word cloud
generate_word_cloud <- function(text) {
  wordcloud(words = strsplit(text, " ")[[1]],
            min.freq = 1,
            scale = c(3, 0.5),
            colors = brewer.pal(8, "Dark2"))
}

crawl_and_parse <- function(url, depth = 1, max_depth = 3) {
  if (depth > max_depth) {
    return()
  }

  cat(paste("Processing: ", url, "\n"))

  # Fetch content from the current page
  html_content <- get_website_content(url)

  # Extract text from HTML content
  website_text <- extract_text_from_html(html_content)

  # Generate and display the word cloud
  generate_word_cloud(website_text)

  # Extract links from the current page
  links <- html_nodes(html_content, "a[href]") %>% html_attr("href")

  # Follow each link recursively
  for (link in links) {
    next_url <- URLencode(paste(url, link, sep = ""))
    crawl_and_parse(next_url, depth = depth + 1, max_depth = max_depth)
  }
}

# URL of the initial website
initial_url <- 'https://www.arch.ox.ac.uk/bioarchaeology'
initial_url <- 'https://www.arch.ox.ac.uk/chronology'
initial_url <- 'https://www.arch.ox.ac.uk/eurasian-prehistory'
initial_url <- 'https://www.arch.ox.ac.uk/historical-and-classical'
initial_url <- 'https://www.arch.ox.ac.uk/materials-and-technology'
initial_url <- 'https://www.arch.ox.ac.uk/palaeolithic'

# Set the maximum depth for recursion
max_recursion_depth <- 1

# Start crawling and parsing
crawl_and_parse(initial_url, max_depth = max_recursion_depth)
