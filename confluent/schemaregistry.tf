data "confluent_schema_registry_region" "default" {
  cloud   = "AWS"
  region  = "us-east-2"
  package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "default" {
  package = data.confluent_schema_registry_region.default.package
  environment {
    id = confluent_environment.default.id
  }
  region {
    id = data.confluent_schema_registry_region.default.id
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_role_binding" "schema-read" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_schema_registry_cluster.default.resource_name}/subject=*"
}

resource "confluent_role_binding" "schema-write" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_schema_registry_cluster.default.resource_name}/subject=*"
}
# FlinkDeveloper

resource "confluent_api_key" "schema-registry-api-key" {
  display_name = "sentiment-analysis-schema-registry-api-key"
  description  = "Schema Registry API Key that is owned by default service account"
  owner {
    id          = confluent_service_account.default.id
    api_version = confluent_service_account.default.api_version
    kind        = confluent_service_account.default.kind
  }

  managed_resource {
    id          = confluent_schema_registry_cluster.default.id
    api_version = confluent_schema_registry_cluster.default.api_version
    kind        = confluent_schema_registry_cluster.default.kind

    environment {
      id = confluent_environment.default.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

