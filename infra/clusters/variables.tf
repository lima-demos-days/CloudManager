variable "clusters" {
  type = list(object({
    cluster_name = string
    cluster_config = object({
      node_pools    = list(string)
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

variable "kubernetes-version" {
  type    = string
  default = "1.32"
}