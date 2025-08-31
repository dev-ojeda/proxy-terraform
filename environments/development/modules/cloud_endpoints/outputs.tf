output "endpoints_service_name" {
  value       = google_endpoints_service.openapi_service.service_name
  sensitive   = true
  description = "Nombre del servicio Endpoints"
}

output "endpoints_host_name" {
  value       = var.host_name
  sensitive   = true
  description = "Hostname público del servicio Endpoints"
}