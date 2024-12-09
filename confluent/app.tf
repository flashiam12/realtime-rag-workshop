locals {
  app_script_path = "${path.module}/../app/scripts"
}

resource "null_resource" "shell_permission" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
    chmod +x "${local.app_script_path}/frontend_app.sh"
    chmod +x "${local.app_script_path}/market_news_scrapper.sh"
    chmod +x "${local.app_script_path}/prompt_embedding_client.sh"
    chmod +x "${local.app_script_path}/news_embedding_client.sh"
    EOT
  }
  depends_on = [ local_file.frontend_app, local_file.market_news_scrapper, local_file.news_embedding_client, local_file.prompt_embedding_client ]
}
resource "local_file" "frontend_app" {
  content  = templatefile("${local.app_script_path}/frontend_app.tpl", 
  {
    CC_KAFKA_RAW_PROMPT_TOPIC       = "${confluent_kafka_topic.PromptRaw.topic_name}"
    CC_KAFKA_PROMPT_RESPONSE_TOPIC  = "success-${confluent_connector.http-sink.id}"
    CC_CLUSTER_KAFKA_URL            = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}"
    CC_CLUSTER_API_KEY              = "${confluent_api_key.cluster-api-key.id}"
    CC_CLUSTER_API_SECRET           = "${confluent_api_key.cluster-api-key.secret}"
    CC_CLUSTER_SR_URL               = "${replace(confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}"
    CC_CLUSTER_SR_USER              = "${confluent_api_key.schema-registry-api-key.id}"
    CC_CLUSTER_SR_PASS              = "${confluent_api_key.schema-registry-api-key.secret}"
  }
  )
  filename = "${local.app_script_path}/frontend_app.sh"
}

resource "local_file" "market_news_scrapper" {
  content  = templatefile("${local.app_script_path}/market_news_scrapper.tpl", 
  {
    COMPANY_OF_INTEREST            = "${var.company_of_interest}",
    NEWSAPI_APIKEY                 = "${var.newsapi_api_key}",
    CC_KAFKA_RAW_NEWS_TOPIC        = "${confluent_kafka_topic.ContextRaw.topic_name}",
    CC_KAFKA_EMBEDDING_NEWS_TOPIC  = "${confluent_kafka_topic.ContextEmbedding.topic_name}",
    CC_CLUSTER_KAFKA_URL           = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}",
    CC_CLUSTER_API_KEY             = "${confluent_api_key.cluster-api-key.id}",
    CC_CLUSTER_API_SECRET          = "${confluent_api_key.cluster-api-key.secret}",
    CC_CLUSTER_SR_URL              = "${replace(confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}",
    CC_CLUSTER_SR_USER             = "${confluent_api_key.schema-registry-api-key.id}",
    CC_CLUSTER_SR_PASS             = "${confluent_api_key.schema-registry-api-key.secret}"
  })
  filename = "${local.app_script_path}/market_news_scrapper.sh"
}

resource "local_file" "news_embedding_client" {
  content  = templatefile("${local.app_script_path}/news_embedding_client.tpl", 
  {
    OPENAI_APIKEY                 = "${var.openai_api_key}",
    CC_KAFKA_RAW_NEWS_TOPIC       = "${confluent_kafka_topic.ContextRaw.topic_name}",
    CC_KAFKA_EMBEDDING_NEWS_TOPIC = "${confluent_kafka_topic.ContextEmbedding.topic_name}",
    CC_CLUSTER_KAFKA_URL          = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}",
    CC_CLUSTER_API_KEY            = "${confluent_api_key.cluster-api-key.id}",
    CC_CLUSTER_API_SECRET         = "${confluent_api_key.cluster-api-key.secret}",
    CC_CLUSTER_SR_URL             = "${replace(confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}",
    CC_CLUSTER_SR_USER            = "${confluent_api_key.schema-registry-api-key.id}",
    CC_CLUSTER_SR_PASS            = "${confluent_api_key.schema-registry-api-key.secret}"
  })
  filename = "${local.app_script_path}/news_embedding_client.sh"
}

resource "local_file" "prompt_embedding_client" {
  content  = templatefile("${local.app_script_path}/prompt_embedding_client.tpl", {
    CC_KAFKA_RAW_PROMPT_TOPIC           = "${confluent_kafka_topic.PromptRaw.topic_name}",
    CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC  = "${confluent_kafka_topic.PromptContextIndex.topic_name}",
    CC_CLUSTER_KAFKA_URL                = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}",
    OPENAI_APIKEY                       = "${var.openai_api_key}",
    CC_CLUSTER_API_KEY                  = "${confluent_api_key.cluster-api-key.id}",
    CC_CLUSTER_API_SECRET               = "${confluent_api_key.cluster-api-key.secret}",
    CC_CLUSTER_SR_URL                   = "${replace(confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}",
    CC_CLUSTER_SR_USER                  = "${confluent_api_key.schema-registry-api-key.id}",
    CC_CLUSTER_SR_PASS                  = "${confluent_api_key.schema-registry-api-key.secret}",
    CC_PROMPT_EMBEDDING_TOPIC           ="${confluent_kafka_topic.PromptEmbedding.topic_name}",
    MONGO_CLUSTER_SERVER_URL            = "${mongodbatlas_cluster.default.connection_strings[0].standard_srv}",
    MONGO_DATABASE_USER                 = "${local.mongo_workshop_database_user}",
    MONGO_DATABASE_PASSWORD             = "${local.mongo_workshop_database_pass}",
    MONGO_DATABASE                      = "${local.mongo_workshop_database}",
    MONGO_COLLECTION                    = "${local.mongo_workshop_database_collection}",
    MONGO_DATABASE_INDEX                = "${local.mongo_workshop_database_index}"
  })
  filename = "${local.app_script_path}/prompt_embedding_client.sh"
}