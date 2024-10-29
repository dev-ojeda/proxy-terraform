output "cloud_run_service_traffic" {
  value = google_cloud_run_v2_service.app_proxy.traffic[0].percent
  sensitive = true
} 

output "cloud_run_service_traffic_key" {
  value = google_cloud_run_v2_service.app_proxy_with_key.traffic[0].percent
  sensitive = true
} 
