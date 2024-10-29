variable "project_tags" {
  type        = map(string)
  description = "Describe los tags del proyecto"
  default     = {
      "project_id" = "$PROJECT_ID",
      "project_number" = "$PROJECT_MUMBER",
      "region" = "$LOCATION",
      "environment" = "$ENVIRONMENT"
      "default_credentials" = "$CRED"
  }
}

variable "service_tags" {
  type        = map(string)
  description = "Describe los tags de los servicios"
  default     = {
      "service_app_proxy" = "$SERVICE",
      "service_app_proxy_key" = "$SERVICE",
      "region" = "$LOCATION",
      "service_accounts" = "$SA",
      "service_host_name" = "$HOST",
      "service_url_name" = "$ENDPOINT"
      "service_url_name_key" = "$ENDPOINT"
  }
}
