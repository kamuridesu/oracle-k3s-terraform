output "k3s_public_ip" {
  description = "Control Plaine Public IP"
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
