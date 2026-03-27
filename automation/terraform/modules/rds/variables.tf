variable "project_name" { type = string }
variable "environment" { type = string }
variable "identifier" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "database_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "kms_key_id" { type = string }
variable "multi_az" { type = bool; default = false }
variable "backup_retention_days" { type = number; default = 7 }
variable "deletion_protection" { type = bool; default = false }
