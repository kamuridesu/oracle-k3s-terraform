output "k3s_public_ip_ipv4" {
  description = "Public IPV4 IP for K3s VMs"
  value = {
    for k, v in module.oci_instance_arm : k  => v
  }
  sensitive = true
}

output "lb_public_ip" {
  description = "Load Balancer Public IP"
  value = {
    for k, v in module.oci_instance : k => v
  }
  sensitive = true
}

output "vault_management_endpoint" {
  description = "Vault management endpoint"
  value = oci_kms_vault.default_vault.management_endpoint
  sensitive = true
}

output "s3_endpoint_url" {
  description = "S3 URL for Object Storage Private Endpoint"
  value       = "https://${oci_objectstorage_private_endpoint.kam-bucket.prefix}-${data.oci_objectstorage_namespace.default.namespace}.private.compat.objectstorage.${var.region}.oci.customer-oci.com"
}
