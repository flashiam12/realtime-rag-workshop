output "vertex_ai_index_endpoint" {
  value = google_vertex_ai_index_endpoint.index_endpoint.id
}

output "gcp_region" {
  value = var.gcp_region
}

output "service_account" {
  value = "${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
}
