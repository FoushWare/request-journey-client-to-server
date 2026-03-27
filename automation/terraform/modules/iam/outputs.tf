output "notes_service_role_arn" {
  value = aws_iam_role.notes_service.arn
}

output "auth_service_role_arn" {
  value = aws_iam_role.auth_service.arn
}

output "backup_job_role_arn" {
  value = aws_iam_role.backup_job.arn
}
