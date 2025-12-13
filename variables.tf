variable "user" {
  description = "User OCID"
  type        = string
  sensitive = true
  validation {
    condition = can(regex("^ocid1\\.user\\.oc[1|2|3]\\.\\..{60}$", var.user))
    error_message = "Invalid user OCID. https://docs.oracle.com/en-us/iaas/Content/General/Concepts/identifiers.htm"
  }
}

variable "fingerprint" {
  description = "User API Key fingerprint"
  type        = string
  sensitive = true
  validation {
    condition = can(regex("^[A-z0-9].+:[A-z0-9]+$", var.fingerprint))
    error_message = "Invalid API key fingerprint"
  }
}

variable "tenancy" {
  description = "User tenancy"
  type        = string
  sensitive = true
  validation {
    condition = can(regex("^ocid1\\.tenancy\\.oc[1|2|3]\\.\\..{60}$", var.tenancy))
    error_message = "Invalid user tenancy"
  }
}

variable "region" {
  description = "User region"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "key_file" {
  description = "User API Key file"
  type        = string
  sensitive = true
  validation {
    condition = fileexists(var.key_file)
    error_message = "User API Key File does not exists"
  }
}

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
  sensitive = true
  validation {
    condition = can(regex("^ocid1\\.tenancy\\.oc[1|2|3]\\.\\..{60}$", var.compartment_id))
    error_message = "Invalid user tenancy"
  }
}

variable "arm64_vms" {
  description = "Name for the VMs"
  type        = list(string)
  default     = ["k3s-cp", "k3s-node"]
}

variable "amd64_vms" {
  description = "Name for the VMs"
  type        = list(string)
  default     = ["load-balancer", "proxy"]
}

variable "public_ip_source" {
  description = "Your public IP adress"
  type        = list(string)
  sensitive = true
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
