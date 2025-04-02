terraform {
  required_providers {
    pingfederate = {
      source = "pingidentity/pingfederate"
      version = "1.4.3"
    }
  }
}

provider "pingfederate" {
  # Configuration options
  username                            = var.pingfederate_admin_username
  password                            = var.pingfederate_admin_password
  https_host                          = var.pingfederate_url
  admin_api_path                      = "/pf-admin-api/v1"
  insecure_trust_all_tls              = true
  x_bypass_external_validation_header = true
  product_version                     = "12.2"
}