output "k3s_public_ip" {
  description = "Control Plaine Public IP"
  value = {
    for k, v in oci_core_instance.vms : k => v.public_ip
  }
}

output "lb_public_ip" {
  description = "Load Balancer Public IP"
  value       = oci_core_instance.load-balancer.public_ip
}
