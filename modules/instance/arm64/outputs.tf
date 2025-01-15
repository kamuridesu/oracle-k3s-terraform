output "public_ip" {
    description = "VM Public IP"
    value = oci_core_instance.arm64.public_ip
}

output "private_ip" {
    description = "VM Private IP"
    value = oci_core_instance.arm64.private_ip
}
