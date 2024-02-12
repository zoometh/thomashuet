import requests
from bs4 import BeautifulSoup
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from urllib.parse import urljoin

# Function to fetch content from a website
def get_website_content(url):
    response = requests.get(url)
    if response.status_code == 200:
        return response.text
    else:
        print(f"Failed to fetch content from {url}")
        return None

# Function to extract text from HTML using BeautifulSoup
def extract_text_from_html(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    text = ' '.join([p.get_text() for p in soup.find_all('p')])
    return text

# Function to generate a word cloud
def generate_word_cloud(text):
    wordcloud = WordCloud(width=800, height=400, background_color='white').generate(text)
    
    # Display the generated image:
    plt.figure(figsize=(10, 5))
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis('off')
    plt.show()

# Function to recursively crawl and parse web pages
def crawl_and_parse(url, depth=1, max_depth=3):
    if depth > max_depth:
        return

    print(f"Processing: {url}")

    # Fetch content from the current page
    html_content = get_website_content(url)

    if html_content:
        # Extract text from HTML content
        website_text = extract_text_from_html(html_content)

        # Generate and display the word cloud
        generate_word_cloud(website_text)

        # Extract links from the current page
        soup = BeautifulSoup(html_content, 'html.parser')
        links = soup.find_all('a', href=True)

        # Follow each link recursively
        for link in links:
            next_url = urljoin(url, link['href'])
            crawl_and_parse(next_url, depth=depth + 1, max_depth=max_depth)

# URL of the initial website
initial_url = 'https://www.arch.ox.ac.uk/bioarchaeology' # 'https://www.arch.ox.ac.uk/people'

# Set the maximum depth for recursion
max_recursion_depth = 1

# Start crawling and parsing
crawl_and_parse(initial_url, max_depth=max_recursion_depth)
