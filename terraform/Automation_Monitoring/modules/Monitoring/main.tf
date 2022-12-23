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

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana-external-endpoint"
    namespace = var.monitoring_namespace
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "prometheus"
      "app.kubernetes.io/name"     = "grafana"
    }
    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
