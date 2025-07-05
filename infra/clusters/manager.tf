locals {
  manager_name = var.clusters[0].cluster_name
  spokes_names = [
    for i in range(1, length(var.clusters)) :
    var.clusters[i].cluster_name
  ]
  kubeconfigs = {
    for name in local.spokes_names : # each cluster key
    name => templatefile(
      "${path.module}/templates/kubeconfig.tpl",
      {
        cluster_name     = name
        cluster_endpoint = module.EKS[name].cluster_endpoint
        cluster_ca_data  = module.EKS[name].cluster_certificate_authority_data # base64 cert
        token            = data.aws_eks_cluster_auth.spokes_auth[name].token
      }
    )
  }
}

//------------EKS and k8s preparation---------------------
data "aws_eks_cluster" "manager" {
  depends_on = [module.EKS]
  name       = local.manager_name
}

data "aws_eks_cluster_auth" "manager-auth" {
  depends_on = [module.EKS, data.aws_eks_cluster.manager]
  name       = local.manager_name
}

data "aws_eks_cluster_auth" "spokes_auth" {
  depends_on = [module.EKS, data.aws_eks_cluster.manager]
  for_each   = toset(local.spokes_names)
  name       = each.value
}


resource "kubernetes_namespace" "flux_system" {
  depends_on = [module.EKS, data.aws_eks_cluster_auth.manager-auth]
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_namespace" "crossplane_system" {
  depends_on = [module.EKS, data.aws_eks_cluster_auth.manager-auth]
  metadata {
    name = "crossplane-system"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_namespace" "business_ns" {
  depends_on = [data.aws_eks_cluster_auth.manager-auth]
  for_each   = toset(local.spokes_names)
  metadata {
    name = lower(each.value)
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_secret" "git_auth" {
  count      = var.github_token != "" ? 1 : 0
  depends_on = [kubernetes_namespace.flux_system]

  metadata {
    name      = "flux-system"
    namespace = "flux-system"
  }

  data = {
    username = "git"
    password = var.github_token
  }

  type = "Opaque"
}

resource "kubernetes_secret" "business_k8s_secrets" {
  depends_on = [kubernetes_namespace.flux_system]
  for_each   = toset(local.spokes_names)

  metadata {
    name      = "cluster-kubeconfig"
    namespace = lower(each.value)
  }

  data = {
    value = local.kubeconfigs[each.value]
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "crossplane_providers" {
  depends_on = [kubernetes_namespace.crossplane_system]
  for_each = toset(local.spokes_names)

  metadata {
    name      = "crossplane-providers"
    namespace = "crossplane-system"
  }

  data = {
    packages = <<-EOF
      ${join("\n", var.crossplane_providers)}
    EOF
  }
}

//------------Helm definition---------------------
resource "helm_release" "flux_operator" {
  depends_on       = [kubernetes_secret.git_auth]
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