#Create a service account
resource "google_service_account" "rag_workshop_service_account" {
  account_id   = "${var.identifier}-service-account"
  display_name = "${var.identifier}-service-account"
}

output "service_account_email" {
  value = google_service_account.rag_workshop_service_account.email
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

resource "google_service_account_key" "rag_workshop_service_account_key" {
  service_account_id = google_service_account.rag_workshop_service_account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "local_file" "service_account_key_json" {
  content  = base64decode(google_service_account_key.rag_workshop_service_account_key.private_key)
  filename = "./credentials/service_account_key.json"
}

