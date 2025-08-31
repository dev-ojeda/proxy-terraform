variable "project_tags" {
  type = object({
    project_id          = string
    project_number      = string
    region              = string
    environment         = string
  })
}

variable "service_tags" {
  type = object({
    service_app_proxy     = string
    service_app_proxy_key = string
    service_accounts      = string
    service_url_name      = string
  })
}