
data "google_project" "project" {}

locals {
  vertex_ai_service_account = "service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
}
output "local_service_account_email" {
  value = local.vertex_ai_service_account
}

#Create a service account
resource "google_service_account" "rag_workshop_service_account" {
  account_id   = "${var.identifier}-service-account"
  display_name = "${var.identifier}-service-account"
}

output "service_account_email" {
  value = google_service_account.rag_workshop_service_account.email
}

output "service_account_display_name" {
  value = google_service_account.rag_workshop_service_account.display_name
}

resource "google_project_iam_binding" "logs_writer" {
  project = var.project_id
  members = ["serviceAccount:${google_service_account.rag_workshop_service_account.email}"]

  role = "roles/logging.logWriter"
}
resource "google_project_iam_binding" "vertex_ai_user" {
  project = var.project_id
  members = ["serviceAccount:${google_service_account.rag_workshop_service_account.email}"]

  role = "roles/aiplatform.user"
}
resource "google_project_iam_binding" "vertex_ai_service_agent" {
  project = var.project_id
  members = ["serviceAccount:${google_service_account.rag_workshop_service_account.email}"]

  role = "roles/aiplatform.serviceAgent"
}

resource "google_project_iam_binding" "ai_platform_service_agent" {
  project = var.project_id
  members = ["serviceAccount:${google_service_account.rag_workshop_service_account.email}"]

  role = "roles/ml.serviceAgent"
}

resource "google_project_iam_binding" "cloud_functions_admin" {
  project = var.project_id
  members = ["serviceAccount:${google_service_account.rag_workshop_service_account.email}"]

  role = "roles/cloudfunctions.admin"
}

resource "google_service_account_key" "rag_workshop_service_account_key" {
  service_account_id = google_service_account.rag_workshop_service_account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "local_file" "service_account_key_json" {
  content  = base64decode(google_service_account_key.rag_workshop_service_account_key.private_key)
  filename = "./credentials/service_account_key.json"
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.identifier}-index-bucket"
  location = "us-central1"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket_iam_member" "object_viewer" {
  bucket = google_storage_bucket.bucket.name  # Replace with your bucket name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${local.vertex_ai_service_account}"
}

resource "google_storage_bucket_iam_member" "bucket_reader" {
  bucket = google_storage_bucket.bucket.name # Replace with your bucket name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${local.vertex_ai_service_account}"
}
resource "google_vertex_ai_index" "index" {
  region   = "us-central1"
  display_name = "${var.identifier}-index"
  description = "index for test"
  metadata {
    contents_delta_uri = "gs://${google_storage_bucket.bucket.name}/contents"
    config {
      dimensions = 768
      approximate_neighbors_count = 20
      shard_size = "SHARD_SIZE_MEDIUM"
      distance_measure_type = "DOT_PRODUCT_DISTANCE"
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count = 1000
          leaf_nodes_to_search_percent = 5
        }
      }
    }
  }
  index_update_method = "STREAM_UPDATE"
}

# Define Vertex AI Index Endpoint
resource "google_vertex_ai_index_endpoint" "index_endpoint" {

  display_name = "${var.identifier}-endpoint"
  description  = "A sample vertex endpoint"
  region       = "us-central1"
  
  public_endpoint_enabled = true
  
}

output "vertex_ai_index_endpoint" {
  value = google_vertex_ai_index_endpoint.index_endpoint.id
}


# Deploy the Vertex AI Index to the Endpoint using gcloud
resource "null_resource" "deploy_index" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud ai index-endpoints deploy-index ${google_vertex_ai_index_endpoint.index_endpoint.id} --deployed-index-id=${var.identifier}_workshop_deployed_index --display-name=deployed_index_name  --index=${google_vertex_ai_index.index.id} --region=${google_vertex_ai_index.index.region} --project=${var.project_id}
    EOT
  }
  
  # Ensure the null_resource runs after the endpoint is created
  depends_on = [
    google_vertex_ai_index.index,
    google_vertex_ai_index_endpoint.index_endpoint
  ]
}

#Create a code storage bucket
resource "google_storage_bucket" "code_bucket" {
  name = "${var.identifier}_code_bucket" 
  location = "us-central1"
}

# Zip the context folder
resource "archive_file" "context_folder_zip" {
  type        = "zip"
  source_dir  = "${path.module}/cloud-functions/context_client"
  output_path = "${path.module}/context.zip"
}

# Upload the zip file to GCS bucket
resource "google_storage_bucket_object" "context_zip" {
  name   = "context.zip"
  bucket = resource.google_storage_bucket.code_bucket.name
  source = archive_file.context_folder_zip.output_path
}


resource "google_storage_bucket_iam_member" "code_object_viewer" {
  bucket = google_storage_bucket.code_bucket.name  # Replace with your bucket name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.rag_workshop_service_account.email}"
}


resource "google_cloudfunctions_function" "context_client" {
  name        = "context_client"
  description = "Context Function"
  runtime     = "python39"
  source_archive_bucket = "${var.identifier}_code_bucket"
  source_archive_object = google_storage_bucket_object.context_zip.name
  entry_point = "context" 
  service_account_email = google_service_account.rag_workshop_service_account.email
  trigger_http = true
  environment_variables = {
    "INDEX_NAME" = "${google_vertex_ai_index.index.id}"
    "REGION" = "us-central1"
    "PROJECT_ID" = var.project_id
  }
  depends_on = [ google_vertex_ai_index.index,google_vertex_ai_index_endpoint.index_endpoint,null_resource.deploy_index ]
}