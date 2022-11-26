data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}
resource "azurerm_kubernetes_cluster" "k8s" {

  location            = data.azurerm_resource_group.resource_group.location
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix
  tags = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2s"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = "kubeconfig"

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}
