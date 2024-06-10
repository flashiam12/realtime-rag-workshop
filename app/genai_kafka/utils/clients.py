from ..utils.types import object_to_dict, TopicBase
from confluent_kafka import Producer, Consumer
from confluent_kafka.serialization import StringSerializer, SerializationContext, MessageField
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.json_schema import JSONSerializer, JSONDeserializer
import time
import queue

class KafkaProducer():

    def __init__(self, 
                 sr_url:str, 
                 sr_user:str, 
                 sr_pass:str, 
                 kafka_bootstrap: str, 
                 kafka_api_key: str,
                 kafka_api_secret: str, 
                 kafka_topic: str,
                 topic_value_sr_str: str
                 ) -> None:
        self.topic = kafka_topic
        schema_registry_url = "https://"+sr_url
        schema_registry_conf = {'url': schema_registry_url, 'basic.auth.user.info': sr_user+":"+sr_pass}
        self.schema_registry_client = SchemaRegistryClient(schema_registry_conf)
        self.string_serializer = StringSerializer('utf_8')
        self.json_serializer = JSONSerializer(topic_value_sr_str, self.schema_registry_client, object_to_dict)
        producer_conf = {
                            'bootstrap.servers': kafka_bootstrap,
                            'security.protocol': 'SASL_SSL',
                            'sasl.mechanisms': 'PLAIN',
                            'sasl.username': kafka_api_key,
                            'sasl.password': kafka_api_secret
                        }
        self.producer = Producer(producer_conf)
    
    def send(self, 
             message: TopicBase
             ):
        self.producer.poll(0.0)
        # print(message.__dict__)
        try:
            self.producer.produce(
                topic=self.topic, 
                key=self.string_serializer(message.id), 
                value=self.json_serializer(message, SerializationContext(self.topic, MessageField.VALUE)),
                on_delivery=self.delivery_report
                )
        except ValueError as e:
            print("Invalid input, discarding record..., Reason: {}".format(e))
        except Exception as e:
            print(e)
    
    def flush(self):
        self.producer.flush()
    
    def close(self):
        self.producer.close()
        return 

    @staticmethod
    def delivery_report(err, msg):
        if err is not None:
            print("Delivery failed for User record {}: {}".format(msg.key(), err))
            return
        print('User record {} successfully produced to {} [{}] at offset {}'.format(
            msg.key(), msg.topic(), msg.partition(), msg.offset()))
        
class KafkaConsumer():

    def __init__(self, 
                sr_url:str, 
                sr_user:str, 
                sr_pass:str, 
                kafka_bootstrap: str, 
                kafka_api_key: str,
                kafka_api_secret: str, 
                kafka_topic: str,
                topic_value_sr_str: str, 
                topic_value_sr_class: TopicBase
                ) -> None:
        self.topic = kafka_topic
        schema_registry_url = "https://"+sr_url
        schema_registry_conf = {'url': schema_registry_url, 'basic.auth.user.info': sr_user+":"+sr_pass}
        self.schema_registry_client = SchemaRegistryClient(schema_registry_conf)
        # self.json_deserializer = JSONDeserializer(topic_value_sr_str, dict_to_object_generator(topic_value_sr_class), self.schema_registry_client)
        self.json_deserializer = JSONDeserializer(topic_value_sr_str, topic_value_sr_class.dict_to_object_generator)
        self.consumer_conf = {
                            'bootstrap.servers': kafka_bootstrap,
                            'security.protocol': 'SASL_SSL',
                            'sasl.mechanisms': 'PLAIN',
                            'sasl.username': kafka_api_key,
                            'sasl.password': kafka_api_secret,
                            'group.id': kafka_topic+"-default-consumer",
                            'auto.offset.reset': "earliest"
                        }
        
    def poll_indefinately(self):
        self.consumer = Consumer(self.consumer_conf)
        self.consumer.subscribe([self.topic])
        print(self.consumer)
        while True:
            try:
                message = self.consumer.poll(1.0)
                if message is not None:
                    message_obj = self.json_deserializer(message.value(), SerializationContext(message.topic(), MessageField.VALUE))
                    yield message_obj
                    time.sleep(2)
                else:
                    continue
            except ValueError as e:
                print(e)
            except Exception as e:
                print(e)
        
    def close(self):
        self.consumer.close()
        return 