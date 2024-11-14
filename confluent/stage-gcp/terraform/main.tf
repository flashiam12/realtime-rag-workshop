data "google_project" "project" {
  project_id = var.gcp_project_id
}

resource "google_project_service" "aiplatform" {
  for_each = toset(var.api_services)

  project = var.gcp_project_id
  service = each.key

  disable_dependent_services = false
}

resource "google_project_iam_binding" "logs_writer" {
  project = var.gcp_project_id
  members = ["serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"]

  role = "roles/logging.logWriter"
}
resource "google_project_iam_binding" "vertex_ai_user" {
  project = var.gcp_project_id
  members = ["serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"]

  role = "roles/aiplatform.user"
}
resource "google_project_iam_binding" "vertex_ai_service_agent" {
  project = var.gcp_project_id
  members = ["serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"]

  role = "roles/aiplatform.serviceAgent"
}

resource "google_project_iam_binding" "ai_platform_service_agent" {
  project = var.gcp_project_id
  members = ["serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"]

  role = "roles/ml.serviceAgent"
}

resource "google_project_iam_binding" "cloud_functions_admin" {
  project = var.gcp_project_id
  members = ["serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"]

  role = "roles/cloudfunctions.serviceAgent"
}
resource "google_project_iam_binding" "artifact_registry_admin" {
  project = var.gcp_project_id
  members = ["serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"]

  role = "roles/artifactregistry.admin"
}

resource "google_storage_bucket" "bucket" {
  project                     = var.gcp_project_id
  name                        = "${var.gcp_project_id}-index-bucket"
  location                    = var.gcp_region
  uniform_bucket_level_access = true
}

resource "google_vertex_ai_index" "index" {
  project      = var.gcp_project_id
  region       = var.gcp_region
  display_name = "${var.gcp_project_id}-index"
  description  = "index for test"
  metadata {
    contents_delta_uri = "gs://${google_storage_bucket.bucket.name}/contents"
    config {
      dimensions                  = 768
      approximate_neighbors_count = 20
      shard_size                  = "SHARD_SIZE_MEDIUM"
      distance_measure_type       = "DOT_PRODUCT_DISTANCE"
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count    = 1000
          leaf_nodes_to_search_percent = 5
        }
      }
    }
  }
  index_update_method = "STREAM_UPDATE"

  depends_on = [google_project_service.aiplatform]
}

# Define Vertex AI Index Endpoint
resource "google_vertex_ai_index_endpoint" "index_endpoint" {
  project      = var.gcp_project_id
  display_name = "${var.gcp_project_id}-workshop-endpoint"
  description  = "A sample vertex endpoint"
  region       = var.gcp_region

  public_endpoint_enabled = true
  depends_on              = [google_vertex_ai_index.index]
}
#Create a code storage bucket
resource "google_storage_bucket" "code_bucket" {
  project  = var.gcp_project_id
  name     = "${var.gcp_project_id}_code_bucket"
  location = var.gcp_region
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
  bucket = google_storage_bucket.code_bucket.name # Replace with your bucket name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
}

# Force create Cloud Functions SA
resource "google_project_service_identity" "cloud_functions_sa" {
  provider = google-beta
  project  = var.gcp_project_id
  service  = "cloudfunctions.googleapis.com"
}


resource "google_project_iam_member" "cloud_functions_member" {
  project = var.gcp_project_id
  role    = "roles/artifactregistry.reader"
  member  = google_project_service_identity.cloud_functions_sa.member
}

resource "google_cloudfunctions_function" "context_client" {
  project = var.gcp_project_id
  region  = var.gcp_region

  name        = "context_client"
  description = "Context Function"
  runtime     = "python39"

  source_archive_bucket = "${var.gcp_project_id}_code_bucket"
  source_archive_object = google_storage_bucket_object.context_zip.name
  entry_point           = "context"
  service_account_email = "${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"

  trigger_http = true

  environment_variables = {
    "INDEX_NAME" = "${google_vertex_ai_index.index.id}"
    "REGION"     = var.gcp_region
    "PROJECT_ID" = var.gcp_project_id
  }

  depends_on = [google_vertex_ai_index.index, google_vertex_ai_index_endpoint.index_endpoint,google_project_iam_binding.artifact_registry_admin]
}


resource "google_vertex_ai_index_endpoint_deployed_index" "deploy_index" {
  display_name      = "vertex-deployed-index"
  deployed_index_id = "workshop_deployed_index"

  index_endpoint        = google_vertex_ai_index_endpoint.index_endpoint.id
  index                 = google_vertex_ai_index.index.id // this is the index that will be deployed onto an endpoint
  enable_access_logging = false
  depends_on = [
    google_vertex_ai_index.index,
    google_vertex_ai_index_endpoint.index_endpoint
  ]
}