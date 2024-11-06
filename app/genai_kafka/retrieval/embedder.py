from ..utils.clients import KafkaConsumer, KafkaProducer
from ..utils.types import  PromptContextIndex,PromptEmbedding
from ..utils.schemas import prompt_context_index_schema_str,prompt_embedding_schema_str
from ..retrieval.vars import  CC_PROMPT_EMBEDDING_TOPIC, RETRIEVAL_PROMPTCONTEXT_INDEX_TOPIC, CC_BOOTSTRAP, CC_API_KEY, CC_API_SECRET, CC_SR_PASSWORD, CC_SR_USER, CC_SR_URL
from ..retrieval.searcher import IndexSearch


def run():
    kafka_consumer = KafkaConsumer(
                                    sr_url=CC_SR_URL,
                                    sr_user=CC_SR_USER,
                                    sr_pass=CC_SR_PASSWORD,
                                    kafka_bootstrap=CC_BOOTSTRAP,
                                    kafka_api_key=CC_API_KEY,
                                    kafka_api_secret=CC_API_SECRET,
                                    kafka_topic=CC_PROMPT_EMBEDDING_TOPIC,
                                    topic_value_sr_class=PromptEmbedding,
                                    topic_value_sr_str=prompt_embedding_schema_str
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
        print(message)
        vectors = message.embedding_vector
        
        if vectors != []:
            match_neighbors = index_search.query_indexes(prompt_embedding=vectors)
            matched_indexes = [entry.id for sublist in match_neighbors for entry in sublist]
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
