data "mongodbatlas_project" "default" {
    name = "Project 0"
}

locals {
  mongo_workshop_database = "sentiment_analysis"
  mongo_workshop_database_user = "confluent"
  mongo_workshop_database_pass = "genaiwithstreaming"
  mongo_workshop_database_collection = "knowledge_news_embeddings"
  mongo_workshop_database_index = "knowledge_news"
}

resource "mongodbatlas_database_user" "default" {
  username           = local.mongo_workshop_database_user
  password           = local.mongo_workshop_database_pass
  project_id         = data.mongodbatlas_project.default.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }

  roles {
    role_name     = "readWrite"
    database_name = local.mongo_workshop_database
  }

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  labels {
    key   = "owner"
    value = "workshop"
  }
  labels {
    key   = "purpose"
    value = "learning"
  }
}

resource "mongodbatlas_cluster" "default" {
    project_id              = data.mongodbatlas_project.default.id
    name                    = "confluent-sentiment-analysis-pipeline"
    provider_name = "TENANT"
    backing_provider_name = "AWS"
    provider_region_name = "US_EAST_1"
    provider_instance_size_name = "M0"
}

resource "mongodbatlas_search_index" "default" {
    project_id = data.mongodbatlas_project.default.id
    name = local.mongo_workshop_database_index
    cluster_name = mongodbatlas_cluster.default.name
    collection_name = local.mongo_workshop_database_collection
    database = local.mongo_workshop_database
    type = "vectorSearch"
    fields = <<-EOF
    [{
        "type": "vector",
        "path": "knowledge_embedding",
        "numDimensions": 1536,
        "similarity": "cosine"
    }]
    EOF
    depends_on = [ confluent_connector.mongo-sink ]
}