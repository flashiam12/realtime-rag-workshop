#! /bin/bash 
export TF_VAR_cc_cloud_api_key="<Confluent Cloud API Key>"
export TF_VAR_cc_cloud_api_secret="<Confluent Cloud API Secret>"
export TF_VAR_newsapi_api_key="<NewsAPI Key - https://newsapi.org/register>"
export TF_VAR_company_of_interest="<Company to use for analysis>"
export TF_VAR_identifier="<Unique Identifier your name/team name[In small caps]>"
export TF_VAR_project_id="<Copy your GCP projectid from Qwiklabs console.>"
export TF_VAR_vertex_ai_index_endpoint="<Copy your vertexai Indx endpoint id from Qwiklabs console."

cd confluent
terraform init
terraform destroy -auto-approve