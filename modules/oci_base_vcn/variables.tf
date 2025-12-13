variable "label" {
  type = string
}

variable "vcn_cidr" {
  type = string
  sensitive = true
}

variable "ipv6_private_cidr" {
  type = list(string)
  sensitive = true
}

variable "ipv6_subnet_cidr" {
  type = string
  sensitive = true
}

variable "compartment_id" {
  type = string
  sensitive = true
  validation {
    condition = can(regex("^ocid1\\.tenancy\\.oc[1|2|3]\\.\\..{60}$", var.compartment_id))
    error_message = "Invalid user tenancy"
  }
}

variable "subnet_cidr" {
  type = string
  sensitive = true
}

variable "drg_id" {
  type = string
  sensitive = true
}

variable "peer_cidr" {
  type = string
  sensitive = true
}

variable "extra_ingress_rules" {
  type = list(object({
    description = string
    source = string
  }))
  sensitive = true
}
