variable "project_tags" {
  type = object({
    project_id          = string
    project_number      = string
    region              = string
    environment         = string
    credentials_path    = string
  })
}

variable "service_tags" {
  type = object({
    service_app_proxy     = string
    service_app_proxy_key = string
    region                = string
    service_accounts      = string
    service_host_name     = string
    service_url_name      = string
    service_url_name_key  = string
  })
}