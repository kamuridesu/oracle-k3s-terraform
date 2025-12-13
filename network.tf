resource "oci_core_drg" "main_drg" {
  compartment_id = var.compartment_id
  display_name = "main-drg"
}

module "vcn_lb" {
  source = "./modules/oci_base_vcn"
  compartment_id = var.compartment_id
  label = "lb"
  vcn_cidr = "11.0.0.0/16"
  subnet_cidr = "11.0.0.0/24"
  ipv6_subnet_cidr = "2603:c021:c008:61ff::/64"
  ipv6_private_cidr = ["2603:c021:c008:61ff::/64"]

  drg_id = oci_core_drg.main_drg.id
  peer_cidr = "10.0.0.0/16"

  extra_ingress_rules = [
    {description = "Allow all ingress", source = "0.0.0.0/0"},
    {description = "Allow all ingress ipv6", source = "::/0"}
  ]
}

module "vcn_k3s" {
  source = "./modules/oci_base_vcn"
  compartment_id = var.compartment_id
  label = "k3s"
  vcn_cidr = "10.0.0.0/16"
  subnet_cidr = "10.0.0.0/24"
  ipv6_private_cidr = ["2603:c021:c005:c800::/64"]
  ipv6_subnet_cidr = "2603:c021:c005:c800::/64"

  drg_id = oci_core_drg.main_drg.id
  peer_cidr = "11.0.0.0/16"

  extra_ingress_rules = [
    for ip in var.public_ip_source : {
      description = "Allow specific ip", source = ip
    }
  ]
}

resource "oci_core_drg_attachment" "lb_attach" {
  drg_id = oci_core_drg.main_drg.id
  vcn_id = module.vcn_lb.vcn_id
}

resource "oci_core_drg_attachment" "k3s_attach" {
  drg_id = oci_core_drg.main_drg.id
  vcn_id = module.vcn_k3s.vcn_id
}

