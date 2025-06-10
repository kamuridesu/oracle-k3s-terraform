output "k3s_public_ip_ipv4" {
  description = "Public IPV4 IP for K3s VMs"
  value = {
    for k, v in module.oci_instance_arm : k  => v
  }
}

output "lb_public_ip" {
  description = "Load Balancer Public IP"
  value = {
    for k, v in module.oci_instance : k => v
  }
}
