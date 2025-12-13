output "vcn_id" {
 value = oci_core_vcn.this.id 
}

output "subnet_id" {
  value = oci_core_subnet.this.id
}

output "ipv6_subnet_cidr" {
  value = var.ipv6_subnet_cidr
}
