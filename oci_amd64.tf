module "oci_instance" {

  providers = {
    oci = oci
  }

  for_each            = toset(var.amd64_vms)
  source              = "./modules/oci_core_instance/amd64"
  name                = each.key
  compartment_id      = var.compartment_id
  ssh_authorized_keys = var.ssh_pub_key
  availability_domain = var.availability_domain
  subnet_id           = oci_core_subnet.lb_subnet.id
  ipv6subnet_cidr     = oci_core_subnet.lb_subnet.ipv6cidr_block


  depends_on = [oci_core_drg_attachment.k3s_drg_attachment, oci_core_drg_attachment.lb_drg_attachment]
}
