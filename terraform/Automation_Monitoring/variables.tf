variable "subscription_id" {
  type        = string
  description = "Azure Used subscription"
  default     = "2bfd66e2-d8f3-4fa4-b3d2-a0e7bc2d39a0"
}

variable "kube_config_path" {
  type    = string
  default = "/home/mahdi/devopsProjects/DevOps-Project-GL5/terraform/AKS/kubeconfig"
}

variable "argocd_ns" {
  type    = string
  default = "argocd"
}
