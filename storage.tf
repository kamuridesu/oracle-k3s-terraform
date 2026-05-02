data "oci_objectstorage_namespace" "default" {
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "default" {
  compartment_id = var.compartment_id
  name           = "kam-bucket"
  namespace      = data.oci_objectstorage_namespace.default.namespace
  access_type    = "NoPublicAccess"
  storage_tier   = "Standard"
  versioning     = "Disabled"
}

resource "oci_core_network_security_group" "os_pe_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_k3s.vcn_id
  display_name   = "object-storage-pe-nsg"
}

resource "oci_core_network_security_group_security_rule" "os_pe_ingress" {
  network_security_group_id = oci_core_network_security_group.os_pe_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "10.0.0.0/16"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_objectstorage_private_endpoint" "kam-bucket" {
  compartment_id = var.compartment_id
  name           = "kam-bucket-private-endpoint"
  namespace      = data.oci_objectstorage_namespace.default.namespace
  prefix         = "kam-bkt"
  subnet_id      = module.vcn_k3s.subnet_id

  access_targets {
    bucket         = oci_objectstorage_bucket.default.name
    compartment_id = var.compartment_id
    namespace      = data.oci_objectstorage_namespace.default.namespace
  }
}
