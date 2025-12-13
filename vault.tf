resource "oci_kms_vault" "default_vault" {

  compartment_id = var.compartment_id
  display_name = "default_vault"
  vault_type = "DEFAULT"
    
}
