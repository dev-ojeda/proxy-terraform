variable "project_id" {
  type = string
  description = "ID del proyecto Google Cloud"
}

variable "service_name" {
  type = string
  description = "Nombre del servicio registrado en Cloud Endpoints"
}

variable "host_name" {
  type = string
  description = "Hostname público del servicio en Cloud Endpoints"
}

variable "openapi_path" {
  type        = string
  description = "Ruta al archivo OpenAPI YAML"
  default     = "openapi-run.yaml"
}