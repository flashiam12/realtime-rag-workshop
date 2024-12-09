from ..utils.clients import BasicKafkaConsumer, KafkaProducer
from ..utils.schemas import prompt_raw_schema_str
from ..utils.types import PromptRaw
from ..frontend.vars import FRONTEND_RAW_PROMPT_TOPIC, FRONTEND_PROMPT_ANSWER_TOPIC, CC_BOOTSTRAP, CC_API_KEY, CC_API_SECRET, CC_SR_URL, CC_SR_USER, CC_SR_PASSWORD
import datetime
import uuid
import time


    
def prompt_emitter():
    kafka_producer = KafkaProducer(
                                    sr_url=CC_SR_URL,
                                    sr_user=CC_SR_USER,
                                    sr_pass=CC_SR_PASSWORD,
                                    kafka_bootstrap=CC_BOOTSTRAP,
                                    kafka_api_key=CC_API_KEY,
                                    kafka_api_secret=CC_API_SECRET,
                                    kafka_topic=FRONTEND_RAW_PROMPT_TOPIC,
                                    topic_value_sr_str=prompt_raw_schema_str
                                )

    while True:
        # Capture user input
        user_input = input("Enter your prompt here (type 'exit' to quit): ")
        if user_input.lower() == 'exit':
            print("Exiting the app...")
            break  # Exit the loop to stop the producer

        # Prepare the event data
        prompt_raw = PromptRaw(
            id=str(uuid.uuid1()),  # Generate a unique ID
            prompt=user_input,
            timestamp=datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
        )

        # Send the event to Kafka
        kafka_producer.send(prompt_raw)
        kafka_producer.flush()
        print("Message sent to Kafka:", prompt_raw)

    # Close the producer after exiting
    # kafka_producer.close()
    print("Kafka producer closed.")
    return

def run():
    prompt_emitter()