#! /bin/bash 

export TF_VAR_cc_cloud_api_key="<Confluent Cloud API Key>"
export TF_VAR_cc_cloud_api_secret="<Confluent Cloud API Secret>"

cd confluent
terraform init
terraform destroy -auto-approve