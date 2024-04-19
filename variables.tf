variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "acr_name" {
    description = "The Azure Container Registry Name"
  type = string
  
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


