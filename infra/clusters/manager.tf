locals {
  cluster-name = var.clusters[0].cluster_name
}

//------------EKS preparation---------------------
data "aws_eks_cluster" "manager" {
  depends_on = [module.EKS]
  name       = local.cluster-name
}

data "aws_eks_cluster_auth" "manager-auth" {
  depends_on = [data.aws_eks_cluster.manager]
  name       = local.cluster-name
}


resource "kubernetes_namespace" "flux_system" {
  depends_on = [data.aws_eks_cluster_auth.manager-auth]
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_secret" "git_auth" {
  count      = var.github-token != "" ? 1 : 0
  depends_on = [kubernetes_namespace.flux_system]

  metadata {
    name      = "flux-system"
    namespace = "flux-system"
  }

  data = {
    username = "git"
    password = var.github-token
  }

  type = "Opaque"
}

//------------Helm definition---------------------
resource "helm_release" "flux_operator" {
  depends_on = [kubernetes_secret.git_auth]
  name             = "flux-operator"
  namespace        = var.flux-setup.namespace
  repository       = var.flux-setup.flux_repository
  chart            = "flux-operator"
  create_namespace = true
}

resource "helm_release" "flux_instance" {
  depends_on = [helm_release.flux_operator]

  name       = "flux"
  namespace  = var.flux-setup.namespace
  repository = var.flux-setup.flux_repository
  chart      = "flux-instance"

  values = [
    file("manager-values/components.yaml")
  ]

  set = [
    {
      name  = "instance.distribution.version"
      value = var.flux-setup.flux_version
    },
    {
      name  = "instance.distribution.registry"
      value = var.flux-setup.flux_registry
    },
    {
      name  = "instance.sync.kind"
      value = "GitRepository"
    },
    {
      name  = "instance.sync.url"
      value = var.flux-setup.git_url
    },
    {
      name  = "instance.sync.path"
      value = var.flux-setup.git_path
    },
    {
      name  = "instance.sync.ref"
      value = var.flux-setup.git_ref
    },
    {
      name  = "instance.sync.pullSecret"
      value = "flux-system"
    }
  ]
}