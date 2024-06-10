#! /bin/bash 

source .venv/bin/activate

export OPENAI_APIKEY="<OpenAI API Key - https://platform.openai.com/api-keys>"
export CC_KAFKA_RAW_NEWS_TOPIC="<Refer Confluent Setup - outputs.txt>"
export CC_KAFKA_EMBEDDING_NEWS_TOPIC="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_KAFKA_URL="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_API_KEY="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_API_SECRET="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_SR_URL="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_SR_USER="<Refer Confluent Setup - outputs.txt>"
export CC_CLUSTER_SR_PASS="<Refer Confluent Setup - outputs.txt>"

python app/build/lib/market_news_embedder.py