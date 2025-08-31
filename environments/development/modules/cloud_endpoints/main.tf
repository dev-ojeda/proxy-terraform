terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
resource "google_endpoints_service" "openapi_service" {
  service_name   = var.service_name
  project        = var.project_id
  openapi_config = file("${path.module}/${var.openapi_path}")
}