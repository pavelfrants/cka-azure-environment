variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "rg-k8s"
}

variable "virtual_network_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "vnet-k8s"
}

variable "location" {
  description = "Name of the Azure region to use for all resources."
  type        = string
  default     = "swedencentral"
}

variable "tags" {
  description = "Tags for resources."
  type        = map(string)
  default = {
    "environment" = "test"
    "purpose"     = "education"
  }
}

variable "ssh_pub_key_path" {
  description = "Path to public SSH key."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}