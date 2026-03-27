variable "project_name" { type = string }
variable "environment" { type = string }
variable "kms_key_id" { type = string }

variable "buckets" {
  type = map(object({
    versioning      = optional(bool, false)
    lifecycle_days  = optional(number, 0)
    glacier_days    = optional(number, 0)
    cors_enabled    = optional(bool, false)
    public_access   = optional(bool, false)
    cloudfront_only = optional(bool, false)
  }))
}
