resource "oci_core_drg" "k3s_drg" {
  compartment_id = var.compartment_id
  display_name   = "k3s-drg"
}

resource "oci_core_vcn" "k3s_vcn" {
  compartment_id          = var.compartment_id
  display_name            = "k3s-vcn"
  cidr_block              = "10.0.0.0/16"
  dns_label               = "k3s"
  is_ipv6enabled          = true
  ipv6private_cidr_blocks = ["2603:c021:c005:c800::/64"]
}

resource "oci_core_subnet" "k3s_subnet" {
  compartment_id = var.compartment_id
  display_name   = "k3s-subnet"
  cidr_block     = "10.0.0.0/24"
  dns_label      = "k3s"
  route_table_id = oci_core_vcn.k3s_vcn.default_route_table_id
  vcn_id         = oci_core_vcn.k3s_vcn.id
  ipv6cidr_block = "2603:c021:c005:c800::/64"
}

resource "oci_core_drg_attachment" "k3s_drg_attachment" {
  vcn_id = oci_core_vcn.k3s_vcn.id
  drg_id = oci_core_drg.k3s_drg.id
}

resource "oci_core_remote_peering_connection" "k3s_rpc" {
  compartment_id = var.compartment_id
  drg_id         = oci_core_drg.k3s_drg.id
  display_name   = "k3s rpc"
}

resource "oci_core_internet_gateway" "k3s-gateway" {
  compartment_id = var.compartment_id
  display_name   = "k3s Internet Gateway"
  vcn_id         = oci_core_vcn.k3s_vcn.id
}

resource "oci_core_default_route_table" "k3s-route-table" {
  manage_default_resource_id = oci_core_vcn.k3s_vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.k3s-gateway.id
  }

  route_rules {
    destination       = "::/0"
    network_entity_id = oci_core_internet_gateway.k3s-gateway.id
  }

  route_rules {
    destination       = oci_core_subnet.lb_subnet.cidr_block
    network_entity_id = oci_core_drg.k3s_drg.id
  }
  display_name = "k3s route table"
}

resource "oci_core_default_security_list" "k3s-security-list" {
  manage_default_resource_id = oci_core_vcn.k3s_vcn.default_security_list_id
  display_name               = "k3s-security-list"

  egress_security_rules {
    description = "Allow all egress ipv4"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  egress_security_rules {
    description = "Allow all egress ipv6"
    destination = "::/0"
    protocol    = "all"
  }

  # ingress_security_rules {
  #   description = "Allow all ingress ipv6"
  #   source = "::/0"
  #   protocol    = "all"
  # }

  ingress_security_rules {
    description = "Allow load balancer ingress ipv4"
    protocol    = "all"
    source      = oci_core_subnet.lb_subnet.cidr_block
  }

  ingress_security_rules {
    description = "Allow subnet ingress ipv4"
    protocol    = "all"
    source      = oci_core_vcn.k3s_vcn.cidr_block
  }

  # ingress_security_rules {
  #   description = "Allow my machine ingress"
  #   protocol    = "all"
  #   source      = var.public_ip_source
  # }

  dynamic "ingress_security_rules" {
    for_each = var.public_ip_source
    content {
      description = "Allow ingress from ${ingress_security_rules.value}"
      protocol    = "all"
      source      = ingress_security_rules.value
    }
  }

}
