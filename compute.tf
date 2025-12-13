module "oci_instance" {

  providers = {
    oci = oci
  }

  for_each            = toset(var.amd64_vms)
  source              = "./modules/oci_core_instance"
  name                = each.key
  compartment_id      = var.compartment_id
  ssh_authorized_keys = var.ssh_pub_key
  availability_domain = var.availability_domain
  subnet_id           = module.vcn_lb.subnet_id
  ipv6subnet_cidr     = module.vcn_lb.ipv6_subnet_cidr
  # https://docs.oracle.com/en-us/iaas/images/image/31315889-5937-462d-aa5d-a324a2a26ed5/index.htm
  os_image = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa5dnsil74ysi3u4f7ajk4aoujv3fvxppbsdxi4onu3ss54ahgwmva"

  depends_on = [oci_core_drg_attachment.lb_attach]
}

module "oci_instance_arm" {

  providers = {
    oci = oci
  }

  for_each            = toset(var.arm64_vms)
  source              = "./modules/oci_core_instance"
  name                = each.key
  compartment_id      = var.compartment_id
  ssh_authorized_keys = var.ssh_pub_key
  availability_domain = var.availability_domain

  shape = "VM.Standard.A1.Flex"
  total_memory = "12"
  total_ocpus = "2"
  subnet_id           = module.vcn_k3s.subnet_id
  ipv6subnet_cidr     = module.vcn_k3s.ipv6_subnet_cidr
  # https://docs.oracle.com/en-us/iaas/images/image/2c243e52-ed4b-4bc5-b7ce-2a94063d2a19/index.htm
  os_image = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaeor33zqzryd3smqgyg2arr4whsuobbtlwzxazovoto5vjnckaacq"

  depends_on = [oci_core_drg_attachment.k3s_attach]
}
