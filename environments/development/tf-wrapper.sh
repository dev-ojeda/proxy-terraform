#!/usr/bin/env bash
set -euo pipefail

# Colores
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

op=${1:-}
env=${2:-}

usage() {
  echo -e "${YELLOW}Uso: $0 {init|plan|apply|destroy} {dev|stg|prod}${NC}"
  exit 1
}

[[ -z "$op" || -z "$env" ]] && usage

# Cargar .env
if [[ -f ".env.${env}" ]]; then
  echo -e "${GREEN}>> Cargando variables de entorno de .env.${env}${NC}"
  set -a
  source ".env.${env}"
  set +a
else
  echo -e "${RED}ERROR: No existe archivo .env.${env}${NC}"
  exit 1
fi

# ✅ Validación de credenciales JSON
if [[ ! -f "${CREDENTIALS_PATH}" ]]; then
  echo -e "${RED}ERROR:${NC} No existe el archivo de credenciales en ${CREDENTIALS_PATH}"
  exit 1
fi

if ! jq -e '.type=="service_account"' "${CREDENTIALS_PATH}" >/dev/null 2>&1; then
  echo -e "${RED}ERROR:${NC} El archivo de credenciales no es válido o falta el campo \"type=service_account\""
  exit 1
fi

echo -e "${GREEN}✔ Credenciales válidas detectadas${NC}"

# Export TF_VARs
export TF_VAR_project_tags=$(jq -n \
  --arg project_id "$PROJECT_ID" \
  --arg project_number "$PROJECT_NUMBER" \
  --arg region "$REGION" \
  --arg environment "$ENVIRONMENT" \
  --arg default_credentials "$CREDENTIALS_PATH" \
  '{project_id:$project_id,project_number:$project_number,region:$region,environment:$environment,default_credentials:$default_credentials}')

export TF_VAR_service_tags=$(jq -n \
  --arg service_app_proxy "$SERVICE_APP_PROXY" \
  --arg service_app_proxy_key "$SERVICE_APP_PROXY_KEY" \
  --arg region "$REGION" \
  --arg service_accounts "$SERVICE_ACCOUNTS" \
  --arg service_host_name "$SERVICE_HOST_NAME" \
  --arg service_url_name "$SERVICE_URL_NAME" \
  --arg service_url_name_key "$SERVICE_URL_NAME_KEY" \
  '{service_app_proxy:$service_app_proxy,service_app_proxy_key:$service_app_proxy_key,region:$region,service_accounts:$service_accounts,service_host_name:$service_host_name,service_url_name:$service_url_name,service_url_name_key:$service_url_name_key}')

# Ejecutar Terraform
case "$op" in
  init)
    terraform init -upgrade && terraform validate
    ;;
  plan)
    terraform plan -out "tfplan.${env}"
    ;;
  apply)
    terraform apply "tfplan.${env}"
    ;;
  destroy)
    terraform plan -destroy -out "tfplan-destroy.${env}" \
      && terraform apply "tfplan-destroy.${env}"
    ;;
  *)
    usage
    ;;
esac
