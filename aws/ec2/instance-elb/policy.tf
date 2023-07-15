module "ses_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-ses-${lower(random_id.detail.hex)}"
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

  name        = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-efs-${lower(random_id.detail.hex)}"
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

  name        = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-secrets-${lower(random_id.detail.hex)}"
  path        = "/"
  description = "Get secrets value"

  policy = data.template_file.secrets_policy.rendered
}

module "s3_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-s3-${lower(random_id.detail.hex)}"
  path        = "/"
  description = "R/W access, no full access"

  policy = file("${path.module}/assets/buckets-policy.json")
}
