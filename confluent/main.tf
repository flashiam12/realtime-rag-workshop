terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = ">= 1.83.0"
    }
    google = {
      source = "hashicorp/google"
      version = "5.23.0"
    }
    
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

provider "confluent" {
    cloud_api_key = var.cc_cloud_api_key
    cloud_api_secret = var.cc_cloud_api_secret
}

variable "cc_cloud_api_key" {}
variable "cc_cloud_api_secret" {}
variable "gemini_api_key" {}
variable "newsapi_api_key" {}
variable "company_of_interest" {}
variable "identifier" {}
variable "project_id" {}


module "stage1" {
  providers = {
    google = google
  }

  source = "./stage-gcp"
  cc_cloud_api_key = var.cc_cloud_api_key
  cc_cloud_api_secret = var.cc_cloud_api_secret
  gemini_api_key = var.gemini_api_key
  newsapi_api_key = var.newsapi_api_key
  company_of_interest = var.company_of_interest
  identifier = var.identifier
  project_id = var.project_id
  

}

module "stage2" {
  providers = {
    confluent = confluent
  }
  source = "./stage-confluent"
  vertex_ai_index_endpoint=module.stage1.vertex_ai_index_endpoint
  service_account_display_name=module.stage1.service_account_display_name
  cc_cloud_api_key = var.cc_cloud_api_key
  cc_cloud_api_secret = var.cc_cloud_api_secret
  gemini_api_key = var.gemini_api_key
  newsapi_api_key = var.newsapi_api_key
  company_of_interest = var.company_of_interest
  identifier = var.identifier
  project_id = var.project_id
  depends_on = [module.stage1]
}
