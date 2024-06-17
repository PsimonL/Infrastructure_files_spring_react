provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}

output "kube_config" {
  description = "Kubernetes config file"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
}

provider "kubernetes" {
  config_path = "${path.module}/kube_config"
}

resource "kubernetes_namespace" "myapp" {
  metadata {
    name = "myapp"
  }
}

resource "kubernetes_deployment" "server" {
  metadata {
    name      = "server"
    namespace = kubernetes_namespace.myapp.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "server"
      }
    }
    template {
      metadata {
        labels = {
          app = "server"
        }
      }
      spec {
        container {
          name  = "server"
          image = "srpl/server-side:1.0.0"
          port {
            container_port = 8080
          }
          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://<DB_ADDRESS>:5432/<DB_NAME>"
          }
          env {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = "<USERNAME>"
          }
          env {
            name  = "SPRING_DATASOURCE_PASSWORD"
            value = "<PASSWORD>"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "server" {
  metadata {
    name      = "server-service"
    namespace = kubernetes_namespace.myapp.metadata[0].name
  }
  spec {
    selector = {
      app = "server"
    }
    port {
      protocol = "TCP"
      port     = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "client" {
  metadata {
    name      = "client"
    namespace = kubernetes_namespace.myapp.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "client"
      }
    }
    template {
      metadata {
        labels = {
          app = "client"
        }
      }
      spec {
        container {
          name  = "client"
          image = "srpl/client-side:1.0.0"
          port {
            container_port = 3000
          }
          env {
            name  = "REACT_APP_SERVER_URL"
            value = "http://server-service.myapp.svc.cluster.local:8080"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "client" {
  metadata {
    name      = "client-service"
    namespace = kubernetes_namespace.myapp.metadata[0].name
  }
  spec {
    selector = {
      app = "client"
    }
    port {
      protocol = "TCP"
      port     = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
