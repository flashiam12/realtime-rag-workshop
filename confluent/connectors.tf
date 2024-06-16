resource "confluent_connector" "mongo-sink" {

  environment {
    id = confluent_environment.default.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }

  config_sensitive = {
    "connection.password" = local.mongo_workshop_database_pass
    "connection.user" = local.mongo_workshop_database_user
    "kafka.api.key" = confluent_api_key.cluster-api-key.id
    "kafka.api.secret" = confluent_api_key.cluster-api-key.secret
  }

  config_nonsensitive = {
    "connection.host" = replace("${mongodbatlas_cluster.default.connection_strings[0].standard_srv}", "mongodb+srv://", "")
    "connector.class" = "MongoDbAtlasSink"
    "database" = local.mongo_workshop_database
    "input.data.format" = "JSON_SR"
    "name" = "knowledge-vector-search-sink"
    "tasks.max" = "1"
    "topics" = confluent_kafka_topic.ContextEmbedding.topic_name
    "collection" = local.mongo_workshop_database_collection
    "doc.id.strategy" = "KafkaMetaDataStrategy"
    "kafka.auth.mode" = "KAFKA_API_KEY"
    "max.batch.size" = "0"
    "max.num.retries" = "3"
  }

  depends_on = [
    confluent_role_binding.cluster-admin,
    confluent_role_binding.topic-write,
    confluent_role_binding.topic-read,
    confluent_role_binding.schema-read,
    mongodbatlas_project_ip_access_list.confluent
  ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_connector" "http-sink" {

  environment {
    id = confluent_environment.default.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }

  config_sensitive = {
    "kafka.api.key": confluent_api_key.cluster-api-key.id
    "kafka.api.secret": confluent_api_key.cluster-api-key.secret
    "sensitive.headers": "Authorization: Bearer ${var.openai_api_key}"
  }

  config_nonsensitive = {
    "connector.class" = "HttpSink"
    "http.api.url" = "https://api.openai.com/v1/chat/completions"
    "input.data.format" = "AVRO"
    "name" = "generation-llm-api-sink"
    "tasks.max" = 1
    "topics" = "PromptContext"
    "auth.type":"NONE"
    "headers": "Content-Type: application/json"
    "header.separator": ","
    "batch.max.size": 1
    "behavior.on.error": "ignore"
    "behavior.on.null.values": "ignore"
    "http.request.timeout.ms": 120000
    "kafka.auth.mode": "KAFKA_API_KEY"
    "request.body.format": "json"
    "request.method": "POST"
    "value.converter": "io.confluent.connect.avro.AvroConverter"
    "key.converter": "io.confluent.connect.avro.AvroConverter"
    "http.connect.timeout.ms": "60000"
    "http.request.timeout.ms": "120000"
    "retry.backoff.ms": "10000"
    "max.retries": 5
    "retry.on.status.codes": "500-"
    "batch.json.as.array": false
    "batch.max.size": 1
  }

  depends_on = [
    confluent_role_binding.cluster-admin,
    confluent_role_binding.topic-write,
    confluent_role_binding.topic-read,
    confluent_role_binding.schema-read,
    confluent_flink_statement.PromptContext
  ]

  lifecycle {
    prevent_destroy = false
  }
}