#!/usr/bin/env bash

inicio=$1
echo "OP: ${inicio}"
if [[ "${inicio}" == "apply" ]]; then
    terraform init -upgrade && terraform plan -out "tfplan" && terraform apply "tfplan"
elif [[ "${inicio}" == "destroy" ]]; then
    terraform plan -destroy -out "tfplan-destroy" && terraform apply "tfplan-destroy"
else
    echo "ERROR"
fi
