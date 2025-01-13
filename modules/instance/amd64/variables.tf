variable "name" {
  type        = string
  description = "VM name"
  default     = "default-arm64"
}

variable "compartment_id" {
  type        = string
  description = "Compartiment ID"
}

variable "availability_domain" {
  type        = string
  description = "Availability Domain"
}

variable "ssh_pub_key" {
  type        = string
  description = "SSH Key to access the VM"
}

variable "image_id" {
  type        = string
  description = "Image ID for the OS of the VM"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to assign to the VM"
}

variable "subnet_ipv6_block" {
  type        = string
  description = "IPV6 Block Subnet"
}