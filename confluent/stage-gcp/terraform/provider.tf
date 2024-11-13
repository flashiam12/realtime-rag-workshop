terraform {

  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.11"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
