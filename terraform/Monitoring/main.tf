resource "kubernetes_namespace" "Work_Namespace" {
  metadata {
    name = var.monitoring_namespace
  }
}


resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "33.1.0"
  namespace  = var.monitoring_namespace

  depends_on = [
    kubernetes_namespace.Work_Namespace
  ]
}
