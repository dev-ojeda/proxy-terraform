resource "google_cloud_run_v2_service_iam_binding" "app_proxy_allow" {
  name     = google_cloud_run_v2_service.app_proxy.name
  location = google_cloud_run_v2_service.app_proxy.location
  project  = google_cloud_run_v2_service.app_proxy.project
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_cloud_run_v2_service_iam_binding" "app_proxy_allow_key" {
  name     = google_cloud_run_v2_service.app_proxy_with_key.name
  location = google_cloud_run_v2_service.app_proxy.location
  project  = google_cloud_run_v2_service.app_proxy.project
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_cloud_run_v2_service" "app_proxy" {

  name     = var.service_tags["service_app_proxy"]
  location = var.project_tags["region"]
  project  = var.project_tags["project_id"]
  
  deletion_protection = false
  template {
    service_account = var.service_tags["service_accounts"]
    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }
    containers {
      image = "gcr.io/${var.project_tags["project_id"]}/proxy-app:0.1"
      name  = "proxy-app-run"
      env {
        name  = "SPv2_ARGS"
        value = "--cors_preset=basic"
      }
      env {
        name  = "TARGET"
        value = var.service_tags["service_url_name"]
      }
    }
  }
}

resource "google_cloud_run_v2_service" "app_proxy_with_key" {
  name     = var.service_tags["service_app_proxy_key"]
  location = var.project_tags["region"]
  project  = var.project_tags["project_id"]

  deletion_protection = false # set to "true" in production

  template {
    service_account = var.service_tags["service_accounts"]
    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }
    containers {
      image = "gcr.io/${var.project_tags["project_id"]}/proxy-app-with-apikey:0.5"
      name  = "proxy-app-key-run"
      env {
        name  = "SPv2_ARGS"
        value = "--cors_preset=basic"
      }
      env {
        name  = "TARGET"
        value = var.service_tags["service_url_name"]
      }
    }
  }
}
