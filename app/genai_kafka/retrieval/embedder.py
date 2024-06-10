from ..utils.clients import KafkaConsumer, KafkaProducer
from ..utils.types import PromptRaw, PromptContextIndex
from ..utils.schemas import prompt_raw_schema_str, prompt_context_index_schema_str
from ..utils.openai import embedding
from ..retrieval.vars import FRONTEND_RAW_PROMPT_TOPIC, RETRIEVAL_PROMPTCONTEXT_INDEX_TOPIC, CC_BOOTSTRAP, CC_API_KEY, CC_API_SECRET, CC_SR_PASSWORD, CC_SR_USER, CC_SR_URL, KNOWLEDGE_OPENAI_APIKEY
from ..retrieval.searcher import IndexSearch


def run():
    kafka_consumer = KafkaConsumer(
                                    sr_url=CC_SR_URL,
                                    sr_user=CC_SR_USER,
                                    sr_pass=CC_SR_PASSWORD,
                                    kafka_bootstrap=CC_BOOTSTRAP,
                                    kafka_api_key=CC_API_KEY,
                                    kafka_api_secret=CC_API_SECRET,
                                    kafka_topic=FRONTEND_RAW_PROMPT_TOPIC,
                                    topic_value_sr_class=PromptRaw,
                                    topic_value_sr_str=prompt_raw_schema_str
                                    )
    kafka_producer = KafkaProducer(
                        sr_url=CC_SR_URL,
                        sr_user=CC_SR_USER,
                        sr_pass=CC_SR_PASSWORD,
                        kafka_bootstrap=CC_BOOTSTRAP,
                        kafka_api_key=CC_API_KEY,
                        kafka_api_secret=CC_API_SECRET,
                        kafka_topic=RETRIEVAL_PROMPTCONTEXT_INDEX_TOPIC,
                        topic_value_sr_str=prompt_context_index_schema_str
                        )
    index_search = IndexSearch()
    for message in kafka_consumer.poll_indefinately():
        vectors = embedding(
            content=message.prompt,
            openai_api=KNOWLEDGE_OPENAI_APIKEY
        )
        
        if vectors != []:
            search_results = index_search.query_indexes(prompt_embedding=vectors)
            matched_indexes = list(map(lambda x: x.get("id", "None"), search_results))
            prompt_context_index = PromptContextIndex(
                                            id=message.id,
                                            prompt=message.prompt,
                                            context_indexes=matched_indexes,
                                            timestamp=message.timestamp
                                            )
            kafka_producer.send(prompt_context_index)
            kafka_producer.flush()
        else:
            pass
    index_search.client.close()
