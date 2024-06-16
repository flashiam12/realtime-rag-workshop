data "confluent_organization" "default" {}

data "confluent_flink_region" "default" {
  cloud   = "AWS"
  region  = "us-east-1"
}

resource "confluent_role_binding" "environment-admin" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.default.resource_name
}

resource "confluent_flink_compute_pool" "default" {
  display_name     = "sentiment_analysis_pipeline_pool"
  cloud            = "AWS"
  region           = "us-east-1"
  max_cfu          = 5
  environment {
    id = confluent_environment.default.id
  }
}

resource "confluent_api_key" "flink-default" {
  display_name = "sentiment-analysis-flink-api-key"
  description  = "Flink API Key that is owned by default service account"
  owner {
    id          = confluent_service_account.default.id
    api_version = confluent_service_account.default.api_version
    kind        = confluent_service_account.default.kind
  }

  managed_resource {
    id          = data.confluent_flink_region.default.id
    api_version = data.confluent_flink_region.default.api_version
    kind        = data.confluent_flink_region.default.kind

    environment {
      id = confluent_environment.default.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [ confluent_role_binding.environment-admin ]
}

resource "confluent_flink_statement" "PromptContext" {
  organization {
    id = data.confluent_organization.default.id
  }
  environment {
    id = confluent_environment.default.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.default.id
  }
  principal {
    id = confluent_service_account.default.id
  }
  statement  = "CREATE TABLE PromptContext (id STRING NOT NULL, temperature DOUBLE NOT NULL, `model` STRING NOT NULL, messages ARRAY<ROW<role STRING NOT NULL, content STRING NOT NULL> NOT NULL> NOT NULL, PRIMARY KEY (`id`) NOT ENFORCED) DISTRIBUTED BY (id) INTO 1 BUCKETS;"
  properties = {
    "sql.current-catalog"  = confluent_environment.default.display_name
    "sql.current-database" = confluent_kafka_cluster.default.display_name
  }
  rest_endpoint = data.confluent_flink_region.default.rest_endpoint
  credentials {
    key    = confluent_api_key.flink-default.id
    secret = confluent_api_key.flink-default.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}