import requests
from bs4 import BeautifulSoup
import json

def scrape_sky_news_business(url):
    """Scrapes business news articles from Sky News and returns them as JSON."""

    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an exception for bad status codes
    except requests.exceptions.RequestException as e:
        print(f"Error fetching URL: {e}")
        return None

    soup = BeautifulSoup(response.content, 'html.parser')

    articles = []
    for article_element in soup.find_all('div', class_='sdc-site-tile__body'):
        title_element = article_element.find('span', class_='sdc-site-tile__headline-text')
        link_element = article_element.find('a', class_='sdc-site-tile__headline-link')
        summary_element = article_element.find('p', class_='sdc-site-tile__description')

        article = {
            'title': title_element.text.strip() if title_element else None,
            'link': 'https://news.sky.com' + link_element['href'] if link_element else None,
            'summary': summary_element.text.strip() if summary_element else None
        }

        articles.append(article)

    return json.dumps(articles, indent=4)

if __name__ == "__main__":
    url = "https://news.sky.com/business"
    news_json = scrape_sky_news_business(url)

    if news_json:
        print(news_json)