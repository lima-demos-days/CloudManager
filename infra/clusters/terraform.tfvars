flux-setup = {
  git_url         = "https://github.com/lima-demos-days/CloudManager"
  git_path        = "config/kubernetes/manager"
  git_ref         = "refs/heads/main"
  flux_version    = "2.x"
  flux_registry   = "ghcr.io/fluxcd"
  flux_repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  namespace       = "flux-system"
}

crossplane_providers = [
  "xpkg.crossplane.io/crossplane-contrib/provider-aws:v0.39.0",
  "xpkg.upbound.io/crossplane-contrib/provider-sql:v0.9.0",
]