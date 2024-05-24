data "oci_core_images" "ubuntu-arm" {
  compartment_id           = var.compartment_id
  display_name = "Canonical-Ubuntu-22.04-aarch64-2024.02.18-0"
  # operating_system         = "Canonical Ubuntu"
  # operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  # sort_by                  = "TIMECREATED"
  # sort_order               = "DESC"
}

resource "oci_core_instance" "vms" {

  for_each            = toset(var.vm_names)
  display_name        = each.key
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  metadata = {
    "ssh_authorized_keys" = var.ssh_pub_key,
  }
  shape = data.oci_core_images.ubuntu-arm.shape
  shape_config {
    memory_in_gbs = "12"
    ocpus         = "2"

  }
  source_details {
    boot_volume_size_in_gbs = 50
    boot_volume_vpus_per_gb = 20
    source_id               = data.oci_core_images.ubuntu-arm.images[0].id
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
