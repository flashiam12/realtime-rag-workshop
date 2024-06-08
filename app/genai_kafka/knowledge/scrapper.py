import httpx
from urllib.parse import urlencode
import json

def scrape_company_news(api_key:str="588d68acf8bf48dfac023b4ddc052945", company:str='tesla'):
    query_params = {
        "q": company,
        "sortBy": "popularity",
        "apiKey": api_key,
        "sources": "bloomberg, financial-post, fortune, the-wall-street-journal",
        "searchIn": "description"
    }

    base_url = "https://newsapi.org/v2/everything"
    req_url = f"{base_url}?{urlencode(query_params)}"

    headers = {
        "Accept": "*/*",
        "User-Agent": "Thunder Client (https://www.thunderclient.com)"
    }

    with httpx.Client() as client:
        response = client.get(req_url, headers=headers)
        all_articles = json.loads(response.text)
        return all_articles
    
