terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  credentials = var.project_tags["default_credentials"]
  project     = var.project_tags["project_id"]
  region      = var.project_tags["region"]
  alias       = "google_mod"
}

module "cloud_run" {
  source = "../../module/cloud_run" 
}

module "cloud_endpoints" {
  source = "../../module/cloud_endpoints"
}
