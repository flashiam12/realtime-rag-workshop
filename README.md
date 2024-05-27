## Confluent Event Driven Workshop 
### GenAI Powered Real time Sentiment Analysis Pipeline 
```bash 
### With Confluent Cloud Kafka as the central nervous system, the idea to operationalize and adopt GenAI managed services from various hyperscalers looks a very feasible reality. 
```

![alt text](./assets/example.png)

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
