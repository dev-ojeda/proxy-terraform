output "endpoints_service_name" {
  value = module.cloud_endpoints.endpoints_service_name
  sensitive = true
}

output "endpoints_host_name" {
  value = module.cloud_endpoints.endpoints_host_name
  sensitive = true
}

output "cloud_run_service_traffic" {
  value = module.cloud_run.cloud_run_service_traffic
  sensitive = true
} 

output "cloud_run_service_traffic_key" {
  value = module.cloud_run.cloud_run_service_traffic_key
  sensitive = true
} 
