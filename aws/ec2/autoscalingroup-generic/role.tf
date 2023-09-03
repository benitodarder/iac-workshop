module "iam_role_ec2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.0"

  trusted_role_services = [
    "ec2.amazonaws.com",
    "ssm.amazonaws.com"
  ]
  trusted_role_actions = [
    "sts:AssumeRole",
    "sts:AssumeRole"
  ]

  create_role             = true
  create_instance_profile = true

  role_name         = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
  role_requires_mfa = false
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    module.ses_policy.arn,
    module.efs_policy.arn,
    module.secrets_policy.arn,
    module.s3_policy.arn
  ]

  depends_on = [module.ses_policy, module.efs_policy.arn]

  tags = merge(
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )
}
