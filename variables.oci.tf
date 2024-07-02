variable "availability_domain" {
  description = "Domain Region"
  type        = string
  default     = "UPcS:SA-SAOPAULO-1-AD-1"
}

variable "ssh_pub_key" {
  description = "SSH Public Key"
  type        = string
}
