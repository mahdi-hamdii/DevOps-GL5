module "monitoring" {
  source               = "./modules/Monitoring"
  monitoring_namespace = "kubernetes-monitoring"
}

resource "kubernetes_namespace" "argocd_ns" {
  metadata {
    annotations = {
      name = var.argocd_ns
    }

    name = var.argocd_ns
  }
}

# resource "argocd_application" "helm" {
#   depends_on = [
#     module.argocd
#   ]
#   metadata {
#     name      = "devops-gl"
#     namespace = "argocd"
#   }

#   wait = true

#   spec {
#     source {
#       repo_url        = "https://github.com/mahdi-hamdii/casa-padel-sfax-monitored.git"
#       path            = "chart"
#       target_revision = "HEAD"
#       helm {
#         value_files = ["values.yml"]
#       }
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = "staging"
#     }
#   }
# }
