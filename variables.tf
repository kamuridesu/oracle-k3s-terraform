variable "user" {
  description = "User OCID"
  type        = string
}

variable "fingerprint" {
  description = "User API Key fingerprint"
  type        = string
}

variable "tenancy" {
  description = "User tenancy"
  type        = string
}

variable "region" {
  description = "User region"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "key_file" {
  description = "User API Key file"
  type        = string
}

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "vm_names" {
  description = "Name for the VMs"
  type        = list(string)
  default     = ["k3s-cp", "k3s-node"]
  # default     = ["k3s-cp"]
}

variable "public_ip_source" {
  description = "Your public IP adress"
  type        = string
}

variable "backend_username" {
  description = "Username for HTTP backend"
  type        = string
  default     = ""
}

variable "backend_password" {
  description = "Password for HTTP backend"
  type        = string
  default     = ""
}

variable "backend_url" {
  description = "URL for HTTP backend"
  type        = string
  default     = ""
}