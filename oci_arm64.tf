resource "oci_core_instance" "vms" {

  for_each            = toset(var.vm_names)
  display_name        = each.key
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  metadata = {
    "ssh_authorized_keys" = var.ssh_pub_key,
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = "12"
    ocpus         = "2"

  }
  source_details {
    boot_volume_size_in_gbs = 50
    boot_volume_vpus_per_gb = 20
    # https://docs.oracle.com/en-us/iaas/images/image/14056353-b727-4b81-a15a-3b5b9c808695/
    source_id               = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaxl7vfxg4tcbk6wiceqcbzvhny4ztvtpsbspg6xbpdk2wjvwnaj3a"
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
    subnet_id                 = oci_core_subnet.k3s_subnet.id
    # ipv6address_ipv6subnet_cidr_pair_details {
    #   ipv6subnet_cidr = oci_core_subnet.k3s_subnet.ipv6cidr_block
    # }
  }

  depends_on = [ oci_core_drg_attachment.k3s_drg_attachment, oci_core_drg_attachment.lb_drg_attachment ]

}
