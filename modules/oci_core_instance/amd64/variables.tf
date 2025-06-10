variable "name" {
  description = "VM Name"
  type        = string
}

variable "compartment_id" {
  type = string
}

variable "availability_domain" {
  type = string
}

variable "ssh_authorized_keys" {
  type = string
}

variable "shape" {
  description = "shape of the VM"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}


variable "os_image" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}

variable "subnet_id" {
  type = string
}

variable "ipv6subnet_cidr" {
  type = string
}
