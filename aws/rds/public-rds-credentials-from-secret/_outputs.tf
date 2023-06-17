output "aws_db_instance_preflight_checks_id" {
  value = aws_db_instance.preflight_checks.id
}

output "aws_db_instance_preflight_checks_endpoint" {
  value = aws_db_instance.preflight_checks.endpoint
}

output "aws_kms_alias_kms_rds_key_alias_name" {
  value = aws_kms_alias.kms_rds_key_alias.name
}