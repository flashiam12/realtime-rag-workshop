import httpx
import json
from ..utils.clients import KafkaConsumer, KafkaProducer
from ..utils.types import ContextRaw, ContextEmbedding
from ..utils.schemas import context_raw_schema_str, context_embedding_schema_str
from ..knowledge.vars import KNOWLEDGE_RAW_NEWS_TOPIC, KNOWLEDGE_EMBEDDING_NEWS_TOPIC, CC_BOOTSTRAP, CC_API_KEY, CC_API_SECRET, CC_SR_PASSWORD, CC_SR_USER, CC_SR_URL


def embedding(openai_api:str="None", content:str="None"):
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer {0}".format(openai_api)
    }
    base_url = "https://api.openai.com/v1/embeddings"
    body = {
        "input": content, 
        "model": "text-embedding-3-small",
        "encoding_format": "float"
    }
    print(content)
    with httpx.Client() as client:
        try:
            response = client.post(base_url, headers=headers, json=body)
            embedding_response = json.loads(response.text)
            # return embedding_response["data"][0]["embedding"]
            return embedding_response.get("data",[])[0].get("embedding",[])
        except:
            return []



def run():
    kafka_consumer = KafkaConsumer(
                                    sr_url=CC_SR_URL,
                                    sr_user=CC_SR_USER,
                                    sr_pass=CC_SR_PASSWORD,
                                    kafka_bootstrap=CC_BOOTSTRAP,
                                    kafka_api_key=CC_API_KEY,
                                    kafka_api_secret=CC_API_SECRET,
                                    kafka_topic=KNOWLEDGE_RAW_NEWS_TOPIC,
                                    topic_value_sr_class=ContextRaw,
                                    topic_value_sr_str=context_raw_schema_str
                                    )
    kafka_producer = KafkaProducer(
                        sr_url=CC_SR_URL,
                        sr_user=CC_SR_USER,
                        sr_pass=CC_SR_PASSWORD,
                        kafka_bootstrap=CC_BOOTSTRAP,
                        kafka_api_key=CC_API_KEY,
                        kafka_api_secret=CC_API_SECRET,
                        kafka_topic=KNOWLEDGE_EMBEDDING_NEWS_TOPIC,
                        topic_value_sr_str=context_embedding_schema_str
                        )
    count = 0
    for message in kafka_consumer.poll_indefinately():
        if count > 10:
            kafka_producer.flush()
            count = 0
        vectors = embedding(
            content=json.dumps(
                {
                    "title": message.title,
                    "description": message.description,
                    "content": message.description,
                    "published_at": message.published_at
                }
            ),
            openai_api=KNOWLEDGE_OPENAI_APIKEY
        )

        if vectors != []:
            news_embedding = ContextEmbedding(
                                            id=message.id,
                                            source=message.source,
                                            knowledge_embedding=vectors,
                                            published_at=message.published_at
                                            )
            kafka_producer.send(news_embedding)
            count = count + 1
        else:
            pass
    kafka_producer.flush()
    kafka_consumer.close()