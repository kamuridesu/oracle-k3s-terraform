variable "name" {
  description = "VM Name"
  type        = string
}

variable "compartment_id" {
  type = string
  sensitive = true
  validation {
    condition = can(regex("^ocid1\\.tenancy\\.oc[1|2|3]\\.\\..{60}$", var.compartment_id))
    error_message = "Invalid user tenancy"
  }
}

variable "availability_domain" {
  type = string
}

variable "ssh_authorized_keys" {
  type = string
  sensitive = true
}

variable "shape" {
  description = "shape of the VM"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}


variable "os_image" {
  type    = string
}

variable "subnet_id" {
  type = string
  sensitive = true
}

variable "ipv6subnet_cidr" {
  type = string
  sensitive = true
}

variable "total_memory" {
  type = string
  default = "1"
}

variable "total_ocpus" {
  type = string
  default = "1"
}
