variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID to apply this config to."
}
variable "gcp_region" {
  type        = string
  description = "The GCP region to apply this config to."
}
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to apply this config to."
}
variable "api_services" {
  type        = list(string)
  description = "The list of API services to enable."
  default = [
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "notebooks.googleapis.com",
    "aiplatform.googleapis.com",
    "datacatalog.googleapis.com",
    "visionai.googleapis.com"
  ]
}
