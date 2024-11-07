resource "null_resource" "default_output" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "" >> outputs.txt
      echo "# Confluent Cloud" > outputs.txt
      echo "CC_ENV_NAME='${confluent_environment.default.display_name}'" >> outputs.txt
      echo "CC_CLUSTER_NAME='${confluent_kafka_cluster.default.display_name}'" >> outputs.txt 
      echo "CC_CLUSTER_ID='${confluent_kafka_cluster.default.display_name}'" >> outputs.txt 
      echo "" >> outputs.txt
      echo "# Confluent Kafka" >> outputs.txt
      echo "CC_CLUSTER_API_KEY='${confluent_api_key.cluster-api-key.id}'" >> outputs.txt
      echo "CC_CLUSTER_API_SECRET='${confluent_api_key.cluster-api-key.secret}'" >> outputs.txt
      echo "CC_CLUSTER_KAFKA_URL='${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}'" >> outputs.txt
      echo "CC_KAFKA_RAW_NEWS_TOPIC='${confluent_kafka_topic.ContextRaw.topic_name}'" >> outputs.txt
      echo "CC_PROMPT_EMBEDDING_TOPIC='${confluent_kafka_topic.PromptEmbedding.topic_name}'" >> outputs.txt
      echo "CC_KAFKA_EMBEDDING_NEWS_TOPIC='${confluent_kafka_topic.ContextEmbedding.topic_name}'" >> outputs.txt
      echo "CC_KAFKA_RAW_PROMPT_TOPIC='${confluent_kafka_topic.PromptRaw.topic_name}'" >> outputs.txt
      echo "CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC='${confluent_kafka_topic.PromptContextIndex.topic_name}'" >> outputs.txt
      echo "CC_RESPONSE_TOPIC='${confluent_kafka_topic.GeneratedResponseTopic.topic_name}'" >> outputs.txt
      echo "CC_KAFKA_PROMPT_ENRICHED_TOPIC='PromptContext'" >> outputs.txt
      echo "" >> outputs.txt
      echo "# Confluent Schema Registry" >> outputs.txt
      echo "CC_CLUSTER_SR_URL='${replace(data.confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}'" >> outputs.txt
      echo "CC_CLUSTER_SR_USER='${confluent_api_key.schema-registry-api-key.id}'" >> outputs.txt
      echo "CC_CLUSTER_SR_PASS='${confluent_api_key.schema-registry-api-key.secret}'" >> outputs.txt
      echo "" >> outputs.txt
      echo "# Confluent Flink" >> outputs.txt
      echo "CC_FLINK_COMPUTE_POOL_NAME='${confluent_flink_compute_pool.default.display_name}'" >> outputs.txt
      echo "CC_FLINK_COMPUTE_POOL_ID='${confluent_flink_compute_pool.default.id}'" >> outputs.txt
      echo "" >> outputs.txt
      echo "# Google Cloud" >> outputs.txt
      echo "GCP_SERVICE_ACCOUNT='${var.service_account_display_name}'" >> outputs.txt
      echo "GCP_SERVICE_ACCOUNT_KEY_PATH='./credentials/service_account_key.json'" >> outputs.txt
      echo "" >> outputs.txt
      echo "# External APIs" >> outputs.txt
      echo "GEMINI_APIKEY='${var.gemini_api_key}'" >> outputs.txt
      echo "NEWSAPI_APIKEY='${var.newsapi_api_key}'" >> outputs.txt
    EOT
  }
}