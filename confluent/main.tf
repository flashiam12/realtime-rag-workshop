terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = "1.76.0"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.16.0"
    }
  }
}

provider "confluent" {
    cloud_api_key = var.cc_cloud_api_key
    cloud_api_secret = var.cc_cloud_api_secret
}

provider "mongodbatlas" {
  public_key = var.mongodbatlas_public_key
  private_key  = var.mongodbatlas_private_key
}

variable "cc_cloud_api_key" {}
variable "cc_cloud_api_secret" {}
variable "mongodbatlas_public_key" {}
variable "mongodbatlas_private_key" {}
variable "openai_api_key" {}
variable "newsapi_api_key" {}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "confluent_ip_addresses" "default" {
  filter {
    clouds        = ["AWS"]
    regions       = ["us-east-1"]
    services      = ["CONNECT"]
    address_types = ["EGRESS"]
  }
}

resource "mongodbatlas_project_ip_access_list" "local" {
  project_id = data.mongodbatlas_project.default.id
  cidr_block = "${chomp(data.http.myip.response_body)}/32"
  comment    = "cidr block for local acc testing"
}

resource "mongodbatlas_project_ip_access_list" "confluent" {
  for_each   = { for ip in data.confluent_ip_addresses.default.ip_addresses : ip.ip_prefix => ip }
  project_id = data.mongodbatlas_project.default.id
  cidr_block = each.value.ip_prefix
  comment    = "cidr block for confluent acc testing"
}

