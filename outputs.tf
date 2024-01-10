output "cp_public_ip" {
  description = "Control Plaine Public IP"
  value       = oci_core_instance.cp-node.public_ip
}
