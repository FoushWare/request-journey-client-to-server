variable "project_name" { type = string }
variable "environment" { type = string }
variable "cluster_name" { type = string }
variable "kubernetes_version" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
    disk_size      = number
    capacity_type  = optional(string, "ON_DEMAND")
  }))
}
