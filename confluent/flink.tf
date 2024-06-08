resource "confluent_flink_compute_pool" "default" {
  display_name     = "sentiment_analysis_pipeline_pool"
  cloud            = "AWS"
  region           = "us-east-2"
  max_cfu          = 5
  environment {
    id = confluent_environment.default.id
  }
}