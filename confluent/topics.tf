resource "confluent_kafka_topic" "ContextRaw" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "ContextRaw"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "ContextEmbedding" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "ContextEmbedding"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "PromptRaw" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "PromptRaw"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "PromptContextIndex" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "PromptContextIndex"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "PromptEnriched" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "PromptEnriched"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}