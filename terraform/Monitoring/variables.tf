variable "kube_config_path" {
  type    = string
  default = "/home/mahdi/devopsProjects/DevOps-Project-GL5/terraform/AKS/kubeconfig"
}

variable "monitoring_namespace" {
  type    = string
  default = "kubernetes-monitoring"
}
