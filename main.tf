terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=6"
    }
  }

  backend "http" {
    address  = var.backend_url
    username = var.backend_username
    password = var.backend_password
  }

}

provider "oci" {
  tenancy_ocid     = var.tenancy
  user_ocid        = var.user
  region           = var.region
  fingerprint      = var.fingerprint
  private_key_path = var.key_file
}
