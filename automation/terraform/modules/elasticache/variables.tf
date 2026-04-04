variable "project_name" { type = string }
variable "environment" { type = string }
variable "cluster_id" { type = string }
variable "node_type" { type = string }
variable "num_shards" { type = number; default = 1 }
variable "replicas_per_shard" { type = number; default = 0 }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "kms_key_id" { type = string }
