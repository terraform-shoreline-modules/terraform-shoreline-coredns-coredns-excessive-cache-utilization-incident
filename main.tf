terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "coredns_excessive_cache_utilization_incident" {
  source    = "./modules/coredns_excessive_cache_utilization_incident"

  providers = {
    shoreline = shoreline
  }
}