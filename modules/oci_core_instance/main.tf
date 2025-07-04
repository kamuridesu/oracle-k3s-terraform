terraform {
    required_providers {
      oci = {
            source = "oracle/oci"
        }
    }
}

resource "oci_core_instance" "amd64" {

  display_name        = var.name
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  metadata = {
    "ssh_authorized_keys" = var.ssh_authorized_keys,
  }
  shape = var.shape
  shape_config {
    memory_in_gbs = var.total_memory
    ocpus         = var.total_ocpus

  }
  source_details {
    boot_volume_size_in_gbs = 50
    boot_volume_vpus_per_gb = 20
    
    source_id   = var.os_image
    source_type = "image"
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
    assign_private_dns_record = "false"
    assign_public_ip          = "true"
    subnet_id                 = var.subnet_id
    assign_ipv6ip             = false
    #ipv6address_ipv6subnet_cidr_pair_details {
      #ipv6subnet_cidr = var.ipv6subnet_cidr
      # }
  }

}
