#! /bin/bash

source .venv/bin/activate

export CC_KAFKA_RAW_PROMPT_TOPIC="${CC_KAFKA_RAW_PROMPT_TOPIC}"
export CC_PROMPT_EMBEDDING_TOPIC="${CC_PROMPT_EMBEDDING_TOPIC}"
export CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC="${CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC}"
export CC_CLUSTER_KAFKA_URL="${CC_CLUSTER_KAFKA_URL}"
export CC_CLUSTER_API_KEY="${CC_CLUSTER_API_KEY}"
export CC_CLUSTER_API_SECRET="${CC_CLUSTER_API_SECRET}"
export CC_CLUSTER_SR_URL="${CC_CLUSTER_SR_URL}"
export CC_CLUSTER_SR_USER="${CC_CLUSTER_SR_USER}"
export CC_CLUSTER_SR_PASS="${CC_CLUSTER_SR_PASS}"
export LOCATION="${LOCATION}"
export PROJECT="${PROJECT}"
export INDEX_ENDPOINT="${INDEX_ENDPOINT}"
export DEPLOYED_INDEX_ID="${DEPLOYED_INDEX_ID}"

python app/build/lib/prompt_index_searcher.py