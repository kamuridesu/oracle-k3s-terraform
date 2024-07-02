terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=5.21.0,<6"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy
  user_ocid        = var.user
  region           = var.region
  fingerprint      = var.fingerprint
  private_key_path = var.key_file
}
