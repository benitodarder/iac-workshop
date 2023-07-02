module "ses_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "iam-policy-ses-${local.settings.tags_common.environment}-${local.settings.instance_name}"
  path        = "/"
  description = "Send emails with SES"

  policy = file("${path.module}/assets/ses-policy.json")
}

data "template_file" "efs_policy" {
  template = file("${path.module}/assets/efs-policy.json.tpl")

  vars = {
    account_id = local.settings.tags_common.account_id
  }
}

module "efs_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "iam-policy-efs-${local.settings.tags_common.environment}-${local.settings.instance_name}"
  path        = "/"
  description = "Describe EFS filesystems"

  policy = data.template_file.efs_policy.rendered
}

data "template_file" "secrets_policy" {
  template = file("${path.module}/assets/secrets-policy.json.tpl")

  vars = {
    account_id = local.settings.tags_common.account_id
    region     = local.settings.tags_common.region
  }
}

module "secrets_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "iam-policy-secrets-${local.settings.tags_common.environment}-${local.settings.instance_name}"
  path        = "/"
  description = "Get secrets value"

  policy = data.template_file.secrets_policy.rendered
}

module "s3_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "iam-policy-s3-${local.settings.tags_common.environment}-${local.settings.instance_name}"
  path        = "/"
  description = "R/W access, no full access"

  policy = file("${path.module}/assets/s3-bucket-policy.json")
}
