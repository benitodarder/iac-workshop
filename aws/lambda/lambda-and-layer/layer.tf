resource "null_resource" "pip_install_requirements" {

  provisioner "local-exec" {
    command = "pip install -r ${local.settings.layer_folder}/python/requirements.txt -t ${local.settings.layer_folder}/python"
  }
}


module "hello_world_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 3.3.1"

  layer_name               = "${local.settings.service_name}-layer-${local.settings.environment}-${local.settings.purpose}"
  description              = "Lambda function to check layer."
  handler                  = "lambdaHandler.lambda_handler"
  compatible_runtimes      = ["python3.10"]
  compatible_architectures = ["x86_64"]

  timeout = 60

  create_layer = true

  tags = local.settings.tags

  source_path = "${local.settings.layer_folder}/"

  depends_on = [
    null_resource.pip_install_requirements
  ]


}
