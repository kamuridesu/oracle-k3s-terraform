output "public_ip" {
  description = "Control Plaine Public IP"
  value       = {
    for k, v in oci_core_instance.vms : k => v.public_ip
  }
}
