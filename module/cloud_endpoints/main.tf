resource "google_endpoints_service" "openapi_service" {
  service_name   = var.service_tags["service_app_proxy"]
  project        = var.project_tags["project_id"]
  openapi_config = file("../../module/cloud_endpoints/openapi-run.yaml")
}
