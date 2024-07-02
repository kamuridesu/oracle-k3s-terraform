resource "oci_core_instance" "load-balancer" {

  display_name        = "load-balancer"
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  metadata = {
    "ssh_authorized_keys" = var.ssh_pub_key,
  }
  shape = "VM.Standard.E2.1.Micro"
  shape_config {
    memory_in_gbs = "1"
    ocpus         = "1"

  }
  source_details {
    boot_volume_size_in_gbs = 50
    boot_volume_vpus_per_gb = 20
    # https://docs.oracle.com/en-us/iaas/images/image/6c21715a-0ab7-4a1c-81bd-ea13855f9505/
    source_id               = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaafofcjtufgtru2pebgnmxprwk6ihl5gpwvv2efi2yttovfgiluvvq"
    source_type             = "image"
  }
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = oci_core_subnet.lb_subnet.id
    # ipv6address_ipv6subnet_cidr_pair_details {
      # ipv6subnet_cidr = oci_core_subnet.lb_subnet.ipv6cidr_block
    # }
  }

  depends_on = [ oci_core_drg_attachment.k3s_drg_attachment, oci_core_drg_attachment.lb_drg_attachment ]
}
