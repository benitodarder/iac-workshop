data "aws_secretsmanager_secret_version" "master_credentials" {
  secret_id = "/${local.settings.environment}/${local.settings.business_unit}/${local.settings.service_name}-${local.settings.service_resource}-${local.settings.purpose}-master-credentials"
}

locals {
  master_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.master_credentials.secret_string
  )
}


resource "aws_db_instance" "preflight_checks" {
  allocated_storage      = 10
  db_subnet_group_name   = local.settings.subnet_group
  engine                 = "mysql"
  engine_version         = "5.7"
  identifier             = "${local.settings.service_name}-${local.settings.service_resource}-${local.settings.environment}-${local.settings.purpose}"
  instance_class         = "db.t3.micro"
  kms_key_id             = aws_kms_key.kms_rds_key.arn
  parameter_group_name   = "default.mysql5.7"
  password               = local.master_credentials.password
  port                   = local.settings.tcp_port
  publicly_accessible    = local.settings.public
  skip_final_snapshot    = local.settings.skip_final_snapshot
  storage_encrypted      = true
  username               = local.master_credentials.user
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
}