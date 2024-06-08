#! /bin/bash 

export TF_VAR_cc_cloud_api_key="2M4MYXKTKT37Z2YO"
export TF_VAR_cc_cloud_api_secret="YOMoD38cnBj6+EyH4fCDaxYh7IyyfXQAZ2VY9EXxH4coNwiM02VdmA9bGwhDAbM/"

cd confluent
terraform init
terraform apply -auto-approve