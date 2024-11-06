
resource "confluent_connector" "vertex_vector_context_sink" {
  environment {
    id = confluent_environment.default.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.default.id
  }

  config_sensitive = {
    "kafka.api.key" = confluent_api_key.cluster-api-key.id
    "kafka.api.secret" = confluent_api_key.cluster-api-key.secret
  }

  config_nonsensitive = {
      "connector.class"= "GoogleCloudFunctionsSink",
      "name"= "ContextSinkConnector",
      "kafka.auth.mode" = "KAFKA_API_KEY"
      "topics"= confluent_kafka_topic.ContextEmbedding.topic_name
      "data.format": "JSON_SR",
      "function.name": "context_client",
      "project.id": var.project_id,
      "gcf.credentials.json": file("${path.module}/../credentials/service_account_key.json"),
      "tasks.max": "1"
  }
  depends_on = [
    confluent_role_binding.cluster-admin,
    confluent_role_binding.topic-write,
    confluent_role_binding.topic-read,
    confluent_role_binding.schema-read,
  ]

  lifecycle {
    prevent_destroy = false
}
}
output "vertex_vector_context_sink" {
  description = "CC Cloud function Sink Connector ID"
  value       = resource.confluent_connector.vertex_vector_context_sink.id
}
