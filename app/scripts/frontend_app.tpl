#! /bin/bash

source .venv/bin/activate

export CC_KAFKA_RAW_PROMPT_TOPIC="${CC_KAFKA_RAW_PROMPT_TOPIC}"
export CC_CLUSTER_KAFKA_URL="${CC_CLUSTER_KAFKA_URL}"
export CC_CLUSTER_API_KEY="${CC_CLUSTER_API_KEY}"
export CC_CLUSTER_API_SECRET="${CC_CLUSTER_API_SECRET}"
export CC_CLUSTER_SR_URL="${CC_CLUSTER_SR_URL}"
export CC_CLUSTER_SR_USER="${CC_CLUSTER_SR_USER}"
export CC_CLUSTER_SR_PASS="${CC_CLUSTER_SR_PASS}"

python app/build/lib/frontend_app.py
sudo yum -y install terraform