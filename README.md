## Confluent Event Driven Workshop 
### GenAI Powered Real time Sentiment Analysis Pipeline 

##### With Confluent Cloud Kafka as the central nervous system, the idea to operationalize and adopt GenAI managed services from various hyperscalers looks a very feasible reality. This hands-on workshop dives deep into building a real-time sentiment analysis pipeline leveraging the power of FlinkSQL, vector databases, and Large Language Models (LLMs). We'll explore how to:

##### *Harness FlinkSQL for data enrichment:* Aggregate real-time financial data and market news analysis, enriching prompts with context retrieved from a vector database using FlinkSQL's powerful JOIN capabilities.
##### *Connect to the AI ecosystem:* Seamlessly integrate embedding models, LLMs, and external APIs through Kafka Connectors, simplifying communication and data flow.
##### *Build scalable pipelines with Confluent Cloud:* Leverage the robustness of Confluent Cloud Kafka clusters and Flink compute pools for real-time processing and analysis.

![alt text](./assets/example2.png)

##### <u>**Real-World Application:**</u>

##### We'll apply these techniques to build a sentiment analysis pipeline, demonstrating how to extract insights from financial data and market news in real-time.
##### <u>**Key Takeaways:**</u> 

##### Participants will gain practical experience with Confluent's "Connect, Process, Stream" paradigm, enabling them to build and deploy their own real-time RAG pipelines using any context search vector database and LLM HTTP endpoint. This workshop provides a stepping stone towards Confluent certification and unlocks new possibilities for real-time data analysis and decision-making.


### **Pre-requisite**
    1. Python3.9 & above
    2. Confluent Cloud Account Access
    3. OpenAI API Key
    4. MongoDB Atlas Account Access
    5. Confluent Cloud CLI 
    6. Terraform CLI

### **Setup**

#### 1. External SaaS
    
```bash
# a. Vector Store

export MONGODB_ATLAS_PUBLIC_KEY="xxxx"
export MONGODB_ATLAS_PRIVATE_KEY="xxxx"

cd external
terraform init
terraform apply

cat vector_store.txt
```

```bash 
# b. LLM API
cd .. # Navigate to Root 
export OPENAI_APIKEY="xxxx"

./scripts/test_llm_api.sh
```

#### 2. Confluent Cloud Setup

```bash 
# a. Confluent Cloud API 
export CONFLUENT_CLOUD_API_KEY="<cloud_api_key>"
export CONFLUENT_CLOUD_API_SECRET="<cloud_api_secret>"
```

```bash
# b. Setup kafka cluster & flink pool 
cd confluent

terraform init
terraform apply -target confluent_kafka_cluster.default -target confluent_flink_compute_pool.default
```

```bash
# c. Setup the topics required for Frontend and market news scrapper

terraform apply -target confluent_kafka_topic.frontend_prompt_raw -target confluent_kafka_topic.news_context_raw -target confluent_kafka_topic.news_context_embedding -target confluent_kafka_topic.retrieval_prompt_contextindex
```

```bash 
# d. Confluent CLI Setup
confluent --help # Check if CLI is installed properly

confluent login # Provide the username & password to signin

confluent env use "<confluent_env>" # Created in 2b

confluent api-key create --resource "<cluster_id>" --description "Cluster Default Key" # Cluster created in 2c

# Store the above api key
```

#### 3. Market News Scrapper App

```bash 
# a. Stock Symbol & Market Selection 

cd .. # Back to root directory
export SCRAP_STOCK_SYMBOL="CFLT"
export STOCK_MARKET="NASDAQ"
```

```bash 
# b. News Producer Kafka Client
export CC_CLUSTER_API_KEY="xxxx" # Created in step 2d
export CC_CLUSTER_API_SECRET="xxxx" # Created in step 2d

export CC_CLUSTER_KAFKA_URL="<bootstrap URL>" # Created in step 2b
export CC_KAFKA_RAW_NEWS_TOPIC="<context raw topic>" # Created in step 2c

./scripts/market_news_scrapper.sh
```


### Real Time Knowledge Pipeline 

#### 1. Process
```bash

export CC_KAFKA_RAW_NEWS_TOPIC="<context raw topic>"
export CC_KAFKA_EMBEDDING_NEWS_TOPIC="<context embedding topic>"
./scripts/news_embedding_client.sh

```
#### 2. Connect
```bash
# a. Create Mongo Atlas Sink connector for News Emdedding Upsert to Mongo Atlas Vector Search

cd confluent
terraform apply -target confluent_connector.knowledge_embedding_mongo_sink 

# b. Get the configurations for the created connector 
confluent connect describe "<cc connector id>" # Created above
```

#### 3. Stream 
```bash

# a. Define flink compute pool id and env id 
export CC_FLINK_COMPUTE_POOL_ID="<flink compute pool id>"
export CC_ENV_ID="<confluent env id>"

# b. Log on to flink shell
confluent flink shell --compute-pool ${CC_FLINK_COMPUTE_POOL_ID} --environment ${CC_ENV_ID}

# c. Check messages in the topic table
SELECT * FROM ${CC_KAFKA_EMBEDDING_NEWS_TOPIC}
```

### Retrieval Pipeline

#### 1. Process 

```bash
# a. Export the required the params

export CC_KAFKA_RAW_PROMPT_TOPIC="<>"
export CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC="<>"
export MONGO_ATLAS_ENDPOINT="<>"
export MONGO_USERNAME="<>"
export MONGO_PASSWORD="<>"

./scripts/prompt_embedding_client.sh
```

#### 2. Stream

```bash
export CC_FLINK_COMPUTE_POOL_ID="<flink compute pool id>"
export CC_ENV_ID="<confluent env id>"

# c. Log on to flink shell
confluent flink shell --compute-pool ${CC_FLINK_COMPUTE_POOL_ID} --environment ${CC_ENV_ID}

# d. Check messages in the topic table
SELECT * FROM ${CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC}

```

### Augmentation & Generation Pipeline

#### 1. Stream 

    Response Topic for Prompt Answer from LLM 

#### 2. Connect 

    LLM Http Sink 

#### 3. Process

    a. Create Enriched Prompt Table
####
    b. Flink SQL to enrich prompt with context text & semantic pre-processing


### Frontend App Testing

    a. Configure Prompt Producer
####
    b. Configure Answer Consumer
####
    c. Run the frontend application with given prompt & answer topics
#### 
    d. Produce the prompt as input and check the answers
####
    e. Check the answer & modify as per the need from the app

### Teardown
