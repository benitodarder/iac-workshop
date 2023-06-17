data "template_file" "kms_rds_policy_template" {
  template = file("${path.module}/assets/kms-policy-rds.json.tpl")
  vars = {
    account_id        = local.settings.account_id
    backup_account_id = local.settings.account_id
  }
}

resource "aws_kms_key" "kms_rds_key" {
  description              = "KMS key RDS for ${local.key_suffix_hyphen}"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy                   = data.template_file.kms_rds_policy_template.rendered
  multi_region             = true
  enable_key_rotation      = true

  tags = merge(
    local.settings.tags,
    {
      "Name" = "kms-custom-${local.key_suffix_hyphen}-${local.settings.service_name}-${local.settings.service_resource}"
    }
  )
}

resource "aws_kms_alias" "kms_rds_key_alias" {
  name          = "alias/kms-custom-${local.key_suffix_hyphen}-${local.settings.service_name}-${local.settings.service_resource}"
  target_key_id = aws_kms_key.kms_rds_key.key_id
}
