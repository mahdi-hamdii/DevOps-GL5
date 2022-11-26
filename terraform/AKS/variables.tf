variable "resource_group_name" {
  type        = string
  description = "RG name in azure"
  default     = "DevOps-GL5-AKS"
}

variable "dns_prefix" {
  type    = string
  default = "gl5k8s"
}
variable "subscription_id" {
  type        = string
  description = "Azure Used subscription"
  default     = "2bfd66e2-d8f3-4fa4-b3d2-a0e7bc2d39a0"
}
variable "cluster_name" {
  type    = string
  default = "gl5k8s"
}

variable "agent_count" {
  default = 1
}

variable "ssh_public_key" {
  type    = string
  default = "./../id_rsa.pub"

}
