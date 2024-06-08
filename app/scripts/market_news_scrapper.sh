#! /bin/bash 

source .venv/bin/activate

export COMPANY_OF_INTEREST="<Company of Interest>"
export NEWSAPI_APIKEY="<News API Key - https://newsapi.org/register>"
export CC_KAFKA_RAW_NEWS_TOPIC="<Refer Confluent Setup - outputs.txt>"
export CC_KAFKA_EMBEDDING_NEWS_TOPIC="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_KAFKA_URL="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_API_KEY="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_API_SECRET="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_SR_URL="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_SR_USER="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_SR_PASS="<Refer Confluent Setup - outputs.txt>"

python app/build/lib/market_news.py