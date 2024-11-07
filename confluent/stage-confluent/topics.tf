resource "confluent_kafka_topic" "ContextRaw" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "ContextRaw"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  partitions_count   = 1
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
  partitions_count   = 1
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
  partitions_count   = 1
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
  partitions_count   = 1
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}


resource "confluent_kafka_topic" "PromptEmbedding" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "PromptEmbedding"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  partitions_count   = 1
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "GeneratedResponseTopic" {
  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }
  topic_name         = "GeneratedResponseTopic"
  rest_endpoint      = confluent_kafka_cluster.default.rest_endpoint
  partitions_count   = 1
  credentials {
    key    = confluent_api_key.cluster-api-key.id
    secret = confluent_api_key.cluster-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
