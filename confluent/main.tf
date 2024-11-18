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
  region  = var.project_region
}

provider "confluent" {
    cloud_api_key = var.cc_cloud_api_key
    cloud_api_secret = var.cc_cloud_api_secret
}

variable "cc_cloud_api_key" {}
variable "cc_cloud_api_secret" {}
variable "newsapi_api_key" {}
variable "company_of_interest" {}
variable "identifier" {}
variable "project_id" {}
variable "vertex_ai_index_endpoint" {}
variable "project_region" {}

# Provisoned with Qwiklabs 
# module "stage1" {
#   providers = {
#     google = google
#   }
#
#   source = "./stage-gcp"
#   cc_cloud_api_key = var.cc_cloud_api_key
#   cc_cloud_api_secret = var.cc_cloud_api_secret
#   newsapi_api_key = var.newsapi_api_key
#   company_of_interest = var.company_of_interest
#   identifier = var.identifier
#   project_id = var.project_id
# }



module "stage2" {
  providers = {
    confluent = confluent
  }
  source = "./stage-confluent"
  vertex_ai_index_endpoint=var.vertex_ai_index_endpoint
  cc_cloud_api_key = var.cc_cloud_api_key
  cc_cloud_api_secret = var.cc_cloud_api_secret
  newsapi_api_key = var.newsapi_api_key
  company_of_interest = var.company_of_interest
  identifier = var.identifier
  project_id = var.project_id
  project_region = var.project_region
}
