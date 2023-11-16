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
}

variable "key_file" {
  description = "User API Key file"
  type        = string
}

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}