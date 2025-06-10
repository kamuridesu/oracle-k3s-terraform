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
}

variable "subnet_id" {
  type = string
}

variable "ipv6subnet_cidr" {
  type = string
}

variable "total_memory" {
  type = string
  default = "1"
}

variable "total_ocpus" {
  type = string
  default = "1"
}
