#! /bin/bash

source .venv/bin/activate

export CC_KAFKA_RAW_PROMPT_TOPIC="${CC_KAFKA_RAW_PROMPT_TOPIC}"
export CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC="${CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC}"
export CC_PROMPT_EMBEDDING_TOPIC="${CC_PROMPT_EMBEDDING_TOPIC}"
export OPENAI_APIKEY="${OPENAI_APIKEY}"
export CC_CLUSTER_KAFKA_URL="${CC_CLUSTER_KAFKA_URL}"
export CC_CLUSTER_API_KEY="${CC_CLUSTER_API_KEY}"
export CC_CLUSTER_API_SECRET="${CC_CLUSTER_API_SECRET}"
export CC_CLUSTER_SR_URL="${CC_CLUSTER_SR_URL}"
export CC_CLUSTER_SR_USER="${CC_CLUSTER_SR_USER}"
export CC_CLUSTER_SR_PASS="${CC_CLUSTER_SR_PASS}"
export MONGO_CLUSTER_SERVER_URL="${MONGO_CLUSTER_SERVER_URL}"
export MONGO_DATABASE_USER="${MONGO_DATABASE_USER}"
export MONGO_DATABASE_PASSWORD="${MONGO_DATABASE_PASSWORD}"
export MONGO_DATABASE="${MONGO_DATABASE}"
export MONGO_COLLECTION="${MONGO_COLLECTION}"
export MONGO_DATABASE_INDEX="${MONGO_DATABASE_INDEX}"

python app/build/lib/prompt_index_searcher.py