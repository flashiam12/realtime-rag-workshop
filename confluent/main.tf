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

# provider "confluent" {
#   alias = "cluster"
#   kafka_api_key = confluent_api_key.cluster-api-key.id
#   kafka_api_secret = confluent_api_key.cluster-api-key.secret
#   kafka_id = confluent_kafka_cluster.default.id
#   kafka_rest_endpoint = confluent_kafka_cluster.default.rest_endpoint
# }

# provider "confluent" {
#   alias = "schema"
#   schema_registry_api_key = confluent_api_key.schema-registry-api-key.id
#   schema_registry_api_secret = confluent_api_key.schema-registry-api-key.secret
#   schema_registry_id = confluent_schema_registry_cluster.default.id
#   schema_registry_rest_endpoint = confluent_schema_registry_cluster.default.id
# }

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
variable "company_of_interest" {}

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

