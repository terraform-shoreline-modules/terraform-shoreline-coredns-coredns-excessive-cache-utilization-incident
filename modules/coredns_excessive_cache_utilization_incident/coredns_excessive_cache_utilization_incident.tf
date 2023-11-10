resource "shoreline_notebook" "coredns_excessive_cache_utilization_incident" {
  name       = "coredns_excessive_cache_utilization_incident"
  data       = file("${path.module}/data/coredns_excessive_cache_utilization_incident.json")
  depends_on = [shoreline_action.invoke_update_deployment_config,shoreline_action.invoke_cdns_set_cache_size]
}

resource "shoreline_file" "update_deployment_config" {
  name             = "update_deployment_config"
  input_file       = "${path.module}/data/update_deployment_config.sh"
  md5              = filemd5("${path.module}/data/update_deployment_config.sh")
  description      = "Increase the resources allocated to the Kubernetes cluster, such as memory or CPU, to accommodate the increased cache utilization."
  destination_path = "/tmp/update_deployment_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cdns_set_cache_size" {
  name             = "cdns_set_cache_size"
  input_file       = "${path.module}/data/cdns_set_cache_size.sh"
  md5              = filemd5("${path.module}/data/cdns_set_cache_size.sh")
  description      = "Configure CoreDNS to limit the maximum size of the cache to prevent it from consuming too many resources."
  destination_path = "/tmp/cdns_set_cache_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_deployment_config" {
  name        = "invoke_update_deployment_config"
  description = "Increase the resources allocated to the Kubernetes cluster, such as memory or CPU, to accommodate the increased cache utilization."
  command     = "`chmod +x /tmp/update_deployment_config.sh && /tmp/update_deployment_config.sh`"
  params      = ["NEW_MEMORY_REQUEST","YOUR_CLUSTER_NAME","NEW_CPU_REQUEST"]
  file_deps   = ["update_deployment_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_deployment_config]
}

resource "shoreline_action" "invoke_cdns_set_cache_size" {
  name        = "invoke_cdns_set_cache_size"
  description = "Configure CoreDNS to limit the maximum size of the cache to prevent it from consuming too many resources."
  command     = "`chmod +x /tmp/cdns_set_cache_size.sh && /tmp/cdns_set_cache_size.sh`"
  params      = ["CACHE_SIZE"]
  file_deps   = ["cdns_set_cache_size"]
  enabled     = true
  depends_on  = [shoreline_file.cdns_set_cache_size]
}

