#! /bin/bash 

export TF_VAR_cc_cloud_api_key="<Confluent Cloud API Key>"
export TF_VAR_cc_cloud_api_secret="<Confluent Cloud API Secret>"
export TF_VAR_mongodbatlas_public_key="<MongoDB Public API Key>"
export TF_VAR_mongodbatlas_private_key="<MongoDB Private API Key>"
export TF_VAR_openai_api_key="<OpenAI API Key - https://platform.openai.com/api-keys>"

cd confluent
terraform init
terraform destroy -auto-approve