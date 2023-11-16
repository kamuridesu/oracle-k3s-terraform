variable "aviability_domain" {
  description = "Domain Region"
  type        = string
  default     = "UPcS:SA-SAOPAULO-1-AD-1"
}

variable "ssh_pub_key" {
  description = "SSH Public Key"
  type        = string
}

variable "oci_image" {
  description = "Image for OCI Operating System"
  type        = string
  default     = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaalnfzlq4plimtjcnmejd2p3aoecohlj2uxua5vymsribmpiqtq4la"
}