data "oci_core_images" "ubuntu-amd64" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "load-balancer" {

  display_name        = "load-balancer"
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  metadata = {
    "ssh_authorized_keys" = var.ssh_pub_key,
  }
  shape = data.oci_core_images.ubuntu-amd64.shape
  shape_config {
    memory_in_gbs = "1"
    ocpus         = "1"

  }
  source_details {
    boot_volume_size_in_gbs = 50
    boot_volume_vpus_per_gb = 20
    source_id               = data.oci_core_images.ubuntu-amd64.images[0].id
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
  }
}
