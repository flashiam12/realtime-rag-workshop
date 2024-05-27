## Confluent Event Driven Workshop 
### GenAI Powered Real time Sentiment Analysis Pipeline 

##### With Confluent Cloud Kafka as the central nervous system, the idea to operationalize and adopt GenAI managed services from various hyperscalers looks a very feasible reality. This hands-on workshop dives deep into building a real-time sentiment analysis pipeline leveraging the power of FlinkSQL, vector databases, and Large Language Models (LLMs). We'll explore how to:

##### *Harness FlinkSQL for data enrichment:* Aggregate real-time financial data and market news analysis, enriching prompts with context retrieved from a vector database using FlinkSQL's powerful JOIN capabilities.
##### *Connect to the AI ecosystem:* Seamlessly integrate embedding models, LLMs, and external APIs through Kafka Connectors, simplifying communication and data flow.
##### *Build scalable pipelines with Confluent Cloud:* Leverage the robustness of Confluent Cloud Kafka clusters and Flink compute pools for real-time processing and analysis.

![alt text](./assets/example.png)

##### <u>**Real-World Application:**</u>

##### We'll apply these techniques to build a sentiment analysis pipeline, demonstrating how to extract insights from financial data and market news in real-time.
##### <u>**Key Takeaways:**</u> 

##### Participants will gain practical experience with Confluent's "Connect, Process, Stream" paradigm, enabling them to build and deploy their own real-time RAG pipelines using any context search vector database and LLM HTTP endpoint. This workshop provides a stepping stone towards Confluent certification and unlocks new possibilities for real-time data analysis and decision-making.




### Pre-requiresite 

### Setup 

#### 1. External SaaS

    a. Emebedding API
####
    b. Vector Store
####
    c. Managed LLM API 

#### 2. Market News Scrapper App

    a. Stock Symbol & Market Selection 
####
    b. News Producer Kafka Client

#### 3. Frontend App
    a. Configure Prompt Producer
####
    b. Configure Answer Consumer

### Real Time Knowledge Pipeline 

#### 1. Stream 

    Response Topic for Raw News Embeddings

#### 2. Connect

    Embedding API Http Sink 

#### 3. Process

    a. Index Upsert to Vector Store
####
    b. Raw News Context Kafka Consumer


### Retrieval Pipeline

#### 1. Stream 

    a. Response Topic for Raw Prompt Embeddings

####

    b. Response Topic for Retrived Index Ids against prompt embeddings

#### 2. Connect 

    Embedding API Http Sink

#### 3. Process

    a. Index Retrieval from Vector Store
####
    b. Prompt + Retrived Index Kafka Producer

### Augmentation & Generation Pipeline

#### 1. Stream 

    Response Topic for Prompt Answer from LLM 

#### 2. Connect 

    LLM Http Sink 

#### 3. Process

    a. Create Enriched Prompt Table
####
    b. Flink SQL to enrich prompt with context text & semantic pre-processing


### Sentimental Analysis for given Symbol

    a. Write a Prompt for the sentimental analysis for a given company
####
    b. Check the answer & modify as per the need

### Teardown
