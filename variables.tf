variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the resource group."
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "node_count" {
  description = "The node count for the AKS cluster."
  type        = number
  default     = 1
}


variable "subscription_id" {
    description = "The Azure Subscription ID"
  type = string
}

variable "client_id" {
    description = "The Azure Client ID"
  type = string
}

variable "client_secret" {
    description = "The Azure Client Secret"
  type = string
}
variable "tenant_id" {
    description = "The Azure Tenant ID"
  type = string
}

