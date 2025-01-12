output "k3s_public_ip_ipv4" {
  description = "Public IPV4 IP for K3s VMs"
  value = {
    for k, v in oci_core_instance.arm64 : k => v.public_ip
  }
}

output "lb_public_ip" {
  description = "Load Balancer Public IP"
  value = {
    for k, v in oci_core_instance.amd64 : k => v.public_ip
  }
}
