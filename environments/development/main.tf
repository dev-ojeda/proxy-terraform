terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  required_version = ">= 1.6.0"
}

# Provider principal con alias
provider "google" {
  alias   = "google_mod"
  project = var.project_tags["project_id"]
  region  = var.project_tags["region"]
  credentials = file(var.project_tags.default_credentials)
}

# ----------------------------
# Módulos
# ----------------------------
module "cloud_run" {
  source    = "./modules/cloud_run"
  providers = { google = google.google_mod }
  project_tags = var.project_tags
  service_tags = var.service_tags 
}

module "cloud_endpoints" {
  source    = "./modules/cloud_endpoints"
  providers = { google = google.google_mod }
  project_id   = var.project_tags.project_id
  service_name = var.service_tags.service_app_proxy
  host_name    = var.service_tags.service_host_name
}