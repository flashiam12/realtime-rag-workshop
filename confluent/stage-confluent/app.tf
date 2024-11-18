locals {
  app_script_path = "${path.module}/../../app/scripts"
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
    EOT
  }
  depends_on = [ local_file.frontend_app, local_file.market_news_scrapper, local_file.prompt_embedding_client ]
}
resource "local_file" "frontend_app" {
  content  = templatefile("${local.app_script_path}/frontend_app.tpl", 
  {
    CC_KAFKA_RAW_PROMPT_TOPIC       = "${confluent_kafka_topic.PromptRaw.topic_name}"
    CC_CLUSTER_KAFKA_URL            = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}"
    CC_CLUSTER_API_KEY              = "${confluent_api_key.cluster-api-key.id}"
    CC_CLUSTER_API_SECRET           = "${confluent_api_key.cluster-api-key.secret}"
    CC_CLUSTER_SR_URL               = "${replace(data.confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}"
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
    CC_CLUSTER_SR_URL              = "${replace(data.confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}",
    CC_CLUSTER_SR_USER             = "${confluent_api_key.schema-registry-api-key.id}",
    CC_CLUSTER_SR_PASS             = "${confluent_api_key.schema-registry-api-key.secret}"
  })
  filename = "${local.app_script_path}/market_news_scrapper.sh"
}

# resource "local_file" "news_embedding_client" {
#   content  = templatefile("${local.app_script_path}/news_embedding_client.tpl", 
#   {
#     OPENAI_APIKEY                 = "${var.openai_api_key}",
#     CC_KAFKA_RAW_NEWS_TOPIC       = "${confluent_kafka_topic.ContextRaw.topic_name}",
#     CC_KAFKA_EMBEDDING_NEWS_TOPIC = "${confluent_kafka_topic.ContextEmbedding.topic_name}",
#     CC_CLUSTER_KAFKA_URL          = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}",
#     CC_CLUSTER_API_KEY            = "${confluent_api_key.cluster-api-key.id}",
#     CC_CLUSTER_API_SECRET         = "${confluent_api_key.cluster-api-key.secret}",
#     CC_CLUSTER_SR_URL             = "${replace(data.confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}",
#     CC_CLUSTER_SR_USER            = "${confluent_api_key.schema-registry-api-key.id}",
#     CC_CLUSTER_SR_PASS            = "${confluent_api_key.schema-registry-api-key.secret}"
#   })
#   filename = "${local.app_script_path}/news_embedding_client.sh"
# }

resource "local_file" "prompt_embedding_client" {
  content  = templatefile("${local.app_script_path}/prompt_embedding_client.tpl", {
    CC_KAFKA_RAW_PROMPT_TOPIC           = "${confluent_kafka_topic.PromptRaw.topic_name}",
    CC_PROMPT_EMBEDDING_TOPIC           = "${confluent_kafka_topic.PromptEmbedding.topic_name}",
    CC_KAFKA_PROMPT_CONTEXTINDEX_TOPIC  = "${confluent_kafka_topic.PromptContextIndex.topic_name}",
    CC_CLUSTER_KAFKA_URL                = "${replace(confluent_kafka_cluster.default.bootstrap_endpoint, "SASL_SSL://", "")}",
    CC_CLUSTER_API_KEY                  = "${confluent_api_key.cluster-api-key.id}",
    CC_CLUSTER_API_SECRET               = "${confluent_api_key.cluster-api-key.secret}",
    CC_CLUSTER_SR_URL                   = "${replace(data.confluent_schema_registry_cluster.default.rest_endpoint, "https://", "")}",
    CC_CLUSTER_SR_USER                  = "${confluent_api_key.schema-registry-api-key.id}",
    CC_CLUSTER_SR_PASS                  = "${confluent_api_key.schema-registry-api-key.secret}"
    LOCATION                            = "${var.project_region}"
    PROJECT                             = "${var.project_id}"
    INDEX_ENDPOINT                      = "${var.vertex_ai_index_endpoint}"
    DEPLOYED_INDEX_ID                   = "workshop_deployed_index"
  })
  filename = "${local.app_script_path}/prompt_embedding_client.sh"
}
