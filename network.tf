resource "oci_core_vcn" "k3s_vcn" {
  compartment_id = var.compartment_id
  display_name   = "k3s-vcn"
  cidr_block     = "10.0.0.0/16"
  dns_label      = "k3s"
}

resource "oci_core_subnet" "k3s_subnet" {
  compartment_id = var.compartment_id
  display_name   = "k3s-subnet"
  cidr_block     = "10.0.0.0/24"
  dns_label      = "k3s"
  route_table_id = oci_core_vcn.k3s_vcn.default_route_table_id
  vcn_id         = oci_core_vcn.k3s_vcn.id
}

resource "oci_core_internet_gateway" "k3s-gateway" {
  compartment_id = var.compartment_id
  display_name   = "K3S Internet Gateway"
  vcn_id         = oci_core_vcn.k3s_vcn.id
}

resource "oci_core_default_route_table" "k3s-route-table" {
  manage_default_resource_id = oci_core_vcn.k3s_vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.k3s-gateway.id
  }
}

resource "oci_core_default_security_list" "k3s-security-list" {
  manage_default_resource_id = oci_core_vcn.k3s_vcn.default_security_list_id
  display_name               = "k3s-security-list"
  egress_security_rules {
    // This is for test only! Don't allow all ports for external networks
    description = "Allow all egress"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules {
    // This is for test only! Don't allow all ports for external networks
    description = "Allow all ingress"
    protocol    = "all"
    source      = "0.0.0.0/0"
  }
}
