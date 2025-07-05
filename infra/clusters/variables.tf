variable "clusters" {
  type = list(object({
    cluster_name = string
    cluster_config = object({
      instance_type = list(string)
      min_size      = number
      max_size      = number
      desired_size  = number
      tags          = optional(map(string))
    })
    vpc = object({
      name = string
      cidr = string
      tags = optional(map(string))
    })
  }))
  default = []
}

variable "crossplane_providers" {
  description = "List of Crossplane provider packages to install"
  type        = list(string)
  default     = []                # you can leave this empty or provide defaults here
}

variable "kubernetes-version" {
  type    = string
  default = "1.32"
}

variable "github_token" {
  type    = string
}

variable "flux-setup" {
  type = object({
    git_url         = string
    git_path        = string
    git_ref         = string
    flux_version    = string
    flux_registry   = string
    flux_repository = string
    namespace       = string
  })
}