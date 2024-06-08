terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = "1.76.0"
    }
  }
}

provider "confluent" {
    cloud_api_key = var.cc_cloud_api_key
    cloud_api_secret = var.cc_cloud_api_secret
}

variable "cc_cloud_api_key" {}
variable "cc_cloud_api_secret" {}