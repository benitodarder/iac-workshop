

module "hello_world_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 3.3.1"

  function_name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}"
  description   = "Lambda function to check layers"
  handler       = "lambdaHandler.lambda_handler"
  runtime       = "python3.10"
  architectures = ["x86_64"]
  timeout       = 60

  lambda_role = aws_iam_role.lambda_layer.arn

  layers = [
    module.hello_world_layer.lambda_layer_arn,
  ]

  source_path = "./src"

  tags = local.settings.tags_common

}
