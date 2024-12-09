resource "confluent_schema" "ContextRaw" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "ContextRaw-value"
  format = "JSON"
  schema = file("../app/schemas/ContextRaw-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_schema" "ContextEmbedding" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "ContextEmbedding-value"
  format = "JSON"
  schema = file("../app/schemas/ContextEmbedding-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_schema" "PromptRaw" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "PromptRaw-value"
  format = "JSON"
  schema = file("../app/schemas/PromptRaw-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_schema" "PromptContextIndex" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "PromptContextIndex-value"
  format = "JSON"
  schema = file("../app/schemas/PromptContextIndex-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_schema" "PromptEnriched" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "PromptEnriched-value"
  format = "JSON"
  schema = file("../app/schemas/PromptEnriched-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_schema" "PromptEmbedding" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "PromptEmbedding-value"
  format = "JSON"
  schema = file("../app/schemas/PromptEmbedding-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_schema" "GeneratedResponseTopic" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.default.id
  }
  rest_endpoint = confluent_schema_registry_cluster.default.rest_endpoint
  subject_name = "GeneratedResponseTopic-value"
  format = "JSON"
  schema = file("../app/schemas/GeneratedResponseTopic-value.json")
  recreate_on_update = false
  hard_delete = true
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
  depends_on=[confluent_schema_registry_cluster.default]
}