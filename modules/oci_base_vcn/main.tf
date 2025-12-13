terraform {
    required_providers {
      oci = {
            source = "oracle/oci"
        }
    }
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  display_name = "${var.label}-vcn"
  cidr_block = var.vcn_cidr
  dns_label = var.label
  is_ipv6enabled = true
  ipv6private_cidr_blocks = var.ipv6_private_cidr
}

resource "oci_core_subnet" "this" {
  compartment_id = var.compartment_id
  display_name = "${var.label}-subnet"
  cidr_block = var.subnet_cidr
  dns_label = var.label
  vcn_id = oci_core_vcn.this.id
  ipv6cidr_block = var.ipv6_subnet_cidr
  route_table_id = oci_core_vcn.this.default_route_table_id
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  display_name = "${var.label} Internet Gateway"
  vcn_id = oci_core_vcn.this.id
}

resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id
  display_name = "${var.label} route table"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.this.id
  }
  route_rules {
    destination = "::/0"
    network_entity_id = oci_core_internet_gateway.this.id
  }

  dynamic "route_rules" {
    for_each = var.drg_id != null ? [1]  : []
    content {
      destination = var.peer_cidr
      network_entity_id = var.drg_id
    }
  }

}

resource "oci_core_default_security_list" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_security_list_id
  display_name = "${var.label}-security-list"

  egress_security_rules {
    description = "Allow all egress"
    destination = "0.0.0.0/0"
    protocol = "all"
  }

  egress_security_rules {
    description =  "Allow all egress ipv6"
    destination = "::/0"
    protocol = "all"
  }

  ingress_security_rules {
    description = "Allow all ingress internal"
    protocol = "all"
    source = var.vcn_cidr
  }

  ingress_security_rules {
    description = "Allow ingress from peer"
    protocol = "all"
    source = var.peer_cidr
  }

  dynamic "ingress_security_rules" {
    for_each = var.extra_ingress_rules
    content {
      description = ingress_security_rules.value.description
      protocol = "all"
      source = ingress_security_rules.value.source
    }
  }
}
