
resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "Basic"
  admin_enabled       = true
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.dns_prefix



  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
  }

  identity {
    type = "SystemAssigned"
  }
}



resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.podAnnotations.prometheus.io/scrape"
    value = "true"
  }

  set {
    name  = "controller.podAnnotations.prometheus.io/port"
    value = "10254"
  }
}

resource "kubernetes_namespace" "cert" {
  metadata {
    name = "cert-manager"
  }
}
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "flagger" {
  name       = "flagger"
  repository = "https://flagger.app/"
  chart      = "flagger"
  namespace  = "ingress-nginx"

  set {
    name  = "prometheus.install"
    value = "true"
  }

  set {
    name  = "meshProvider"
    value = "nginx"
  }
}

resource "kubernetes_namespace" "loadtest" {
  metadata {
    name = "loadtester"
  }
}

resource "helm_release" "flagger_loadtester" {
  name       = "flagger-loadtester"
  repository = "https://flagger.app/"
  chart      = "loadtester"
  namespace  = "loadtester"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus_stack" {
  name       = "prometh"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-community/kube-prometheus-stack"
  namespace  = "monitoring"

  values = [
    "${file("monitoring/values.yaml")}"
  ]
}
