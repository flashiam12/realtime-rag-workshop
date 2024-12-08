resource "confluent_service_account" "default" {
  display_name = "sentiment_analysis"
  description  = "Service Account for sentiment analysis pipeline"
}

resource "confluent_environment" "default" {
  display_name = "confluent_workshop"
  stream_governance {
    package = "ESSENTIALS"
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_cluster" "default" {
  display_name = "sentiment_analysis"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "${var.project_region}"
  standard {}

  environment {
    id = confluent_environment.default.id
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_role_binding" "cluster-admin" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.default.rbac_crn
}

resource "confluent_role_binding" "topic-write" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.default.rbac_crn}/kafka=${confluent_kafka_cluster.default.id}/topic=*"
}

resource "confluent_role_binding" "topic-read" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.default.rbac_crn}/kafka=${confluent_kafka_cluster.default.id}/topic=*"
}


resource "confluent_api_key" "cluster-api-key" {
  display_name = "sentiment-analysis-kafka-api-key"
  description  = "Kafka API Key that is owned by default service account"
  owner {
    id          = confluent_service_account.default.id
    api_version = confluent_service_account.default.api_version
    kind        = confluent_service_account.default.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.default.id
    api_version = confluent_kafka_cluster.default.api_version
    kind        = confluent_kafka_cluster.default.kind

    environment {
      id = confluent_environment.default.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}
