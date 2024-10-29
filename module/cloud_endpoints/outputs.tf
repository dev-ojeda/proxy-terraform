output "cloud_run_endpoints" {
  value = google_endpoints_service.openapi_service.service_name
  sensitive = true
}
