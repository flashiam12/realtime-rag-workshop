from ..knowledge.scrapper import scrape_company_news
from ..utils.types import ContextRaw
from ..utils.schemas import context_raw_schema_str
from ..utils.clients import KafkaProducer
from ..knowledge.vars import KNOWLEDGE_NEWSAPI_APIKEY, KNOWLEDGE_COMPANY, KNOWLEDGE_RAW_NEWS_TOPIC, CC_BOOTSTRAP, CC_API_KEY, CC_API_SECRET, CC_SR_PASSWORD, CC_SR_USER, CC_SR_URL


def run():
    news_articles = scrape_company_news(KNOWLEDGE_NEWSAPI_APIKEY, KNOWLEDGE_COMPANY).get("articles", [])
    kafka_producer = KafkaProducer(
                    sr_url=CC_SR_URL,
                    sr_user=CC_SR_USER,
                    sr_pass=CC_SR_PASSWORD,
                    kafka_bootstrap=CC_BOOTSTRAP,
                    kafka_api_key=CC_API_KEY,
                    kafka_api_secret=CC_API_SECRET,
                    kafka_topic=KNOWLEDGE_RAW_NEWS_TOPIC,
                    topic_value_sr_str=context_raw_schema_str
                    )
    
    count = 0
    for i, news in enumerate(news_articles):
        if count > 10:
            kafka_producer.flush()
            count = 0
        news_context = ContextRaw(
                            id = KNOWLEDGE_COMPANY+"-"+str(i),
                            title = news.get("title", "None"),
                            description = news.get("description", "None"),
                            content = news.get("content", "None"),
                            source = news.get("source", {}).get("id", "None"),
                            published_at= news.get("publishedAt", "2024-06-04T11:36:01Z")
                            )
        kafka_producer.send(message=news_context)
        count = count + 1 
    
    kafka_producer.flush()
        





