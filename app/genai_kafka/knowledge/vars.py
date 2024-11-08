import os

KNOWLEDGE_COMPANY = os.environ.get("COMPANY_OF_INTEREST")
KNOWLEDGE_NEWSAPI_APIKEY = os.environ.get("NEWSAPI_APIKEY")
KNOWLEDGE_RAW_NEWS_TOPIC = os.environ.get("CC_KAFKA_RAW_NEWS_TOPIC")
KNOWLEDGE_EMBEDDING_NEWS_TOPIC = os.environ.get("CC_KAFKA_EMBEDDING_NEWS_TOPIC")
CC_BOOTSTRAP = os.environ.get("CC_CLUSTER_KAFKA_URL")
CC_API_KEY = os.environ.get("CC_CLUSTER_API_KEY")
CC_API_SECRET = os.environ.get("CC_CLUSTER_API_SECRET")
CC_SR_URL = os.environ.get("CC_CLUSTER_SR_URL")
CC_SR_USER = os.environ.get("CC_CLUSTER_SR_USER")
CC_SR_PASSWORD = os.environ.get("CC_CLUSTER_SR_PASS")
