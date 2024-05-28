terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.16.0"
    }
  }
}

provider "mongodbatlas" {}