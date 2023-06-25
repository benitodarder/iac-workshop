data "template_file" "lambda_assume_role" {
  template = file("${path.module}/assets/lambda-assume-role.json")
}

resource "aws_iam_role" "lambda_layer" {
  name               = "iam-role-${local.settings.service_name}-${local.settings.service_resource}-${local.settings.environment}-${local.settings.purpose}"
  tags               = local.settings.tags
  assume_role_policy = data.template_file.lambda_assume_role.rendered
}


data "template_file" "lambda_logs_policy_template" {
  template = file("${path.module}/assets/lambda-logs.json.tpl")
  vars = {
    account_id  = local.settings.account_id
    lambda_name = "${local.settings.service_name}-${local.settings.service_resource}-${local.settings.environment}-${local.settings.purpose}"
    region      = local.settings.region
  }
}


resource "aws_iam_policy" "lambda_logs_policy" {
  name   = "iam-policy-${local.settings.service_name}-${local.settings.service_resource}-${local.settings.environment}-${local.settings.purpose}"
  policy = data.template_file.lambda_logs_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach_campaigns" {
  role       = aws_iam_role.lambda_layer.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}
