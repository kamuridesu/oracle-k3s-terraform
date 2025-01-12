resource "oci_core_drg" "lb_drg" {
  compartment_id = var.compartment_id
  display_name   = "lb-drg"
}

resource "oci_core_vcn" "lb_vcn" {
  compartment_id = var.compartment_id
  display_name   = "lb-vcn"
  cidr_block     = "11.0.0.0/16"
  dns_label      = "lb"
  is_ipv6enabled = true
  ipv6private_cidr_blocks = [ "2603:c021:c008:61ff::/64" ]
}

resource "oci_core_subnet" "lb_subnet" {
  compartment_id = var.compartment_id
  display_name   = "lb-subnet"
  cidr_block     = "11.0.0.0/24"
  dns_label      = "lb"
  route_table_id = oci_core_vcn.lb_vcn.default_route_table_id
  vcn_id         = oci_core_vcn.lb_vcn.id
  ipv6cidr_block = "2603:c021:c008:61ff::/64"
}

resource "oci_core_drg_attachment" "lb_drg_attachment" {
  vcn_id = oci_core_vcn.lb_vcn.id
  drg_id = oci_core_drg.lb_drg.id
}

resource "oci_core_remote_peering_connection" "lb_rpc" {
  compartment_id = var.compartment_id
  drg_id         = oci_core_drg.lb_drg.id
  display_name   = "lb rpc"
}

resource "oci_core_internet_gateway" "lb-gateway" {
  compartment_id = var.compartment_id
  display_name   = "lb Internet Gateway"
  vcn_id         = oci_core_vcn.lb_vcn.id
}

resource "oci_core_default_route_table" "lb-route-table" {
  manage_default_resource_id = oci_core_vcn.lb_vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.lb-gateway.id
  }
  route_rules {
    destination       = "::/0"
    network_entity_id = oci_core_internet_gateway.lb-gateway.id
  }
  route_rules {
    destination       = oci_core_subnet.k3s_subnet.cidr_block
    network_entity_id = oci_core_drg.lb_drg.id
  }
  display_name = "lb route table"
}

resource "oci_core_default_security_list" "lb-security-list" {
  manage_default_resource_id = oci_core_vcn.lb_vcn.default_security_list_id
  display_name               = "lb-security-list"

  egress_security_rules {
    description = "Allow all egress"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    description = "Allow all ingress"
    protocol    = "all"
    source      = "0.0.0.0/0"
  }

  egress_security_rules {
    description = "Allow all egress ipv6"
    destination = "::/0"
    protocol    = "all"
  }

  ingress_security_rules {
    description = "Allow all ingress ipv6"
    protocol    = "all"
    source      = "::/0"
  }

}

