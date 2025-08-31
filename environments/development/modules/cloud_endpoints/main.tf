terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
resource "google_endpoints_service" "openapi_service" {
  service_name   = var.service_tags.service_app_proxy
  project        = var.project_tags.project_id
  openapi_config = templatefile("${path.module}/openapi-run.yaml", {
    HOST     = var.service_tags.service_host_name
    ENDPOINT = "https://${var.service_tags.service_url_name}-${var.project_tags.project_number}.${var.project_tags.region}.run.app"
  })
}