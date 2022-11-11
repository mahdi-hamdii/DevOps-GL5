variable "resource_group_name" {
  type = string
  description = "RG name in azure"
}

variable "location" {
  type = string
  description = "Ressources location in Azure"
}

variable "subscription_id" {
  type = string
  description = "Azure Used subscription"
}

variable "worker-nic-names" {
  type = list(string)
}

variable "workers" {
  type = list(string)
}

variable "worker-size" {
  type = string
}

variable "worker-admin-username" {
  type = string
  default = "adminuser"
}