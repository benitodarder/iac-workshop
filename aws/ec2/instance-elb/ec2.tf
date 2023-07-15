data "template_file" "cloudinit_provisioner" {
  template = file(local.settings.cloud_init_file_path)

  vars = {
    region = local.settings.tags_common.region
  }
}

module "ec2-instance-base" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2"

  name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"

  ami                    = random_id.detail.keepers.ami_id
  instance_type          = local.settings.instance_type
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = data.aws_subnets.filter.ids[0]
  iam_instance_profile   = module.iam_role_ec2.iam_role_name
  key_name               = local.settings.key_pair_name

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 100
      encrypted   = true
    },
  ]

  user_data_base64 = base64encode(data.template_file.cloudinit_provisioner.rendered)

  enable_volume_tags = true
  volume_tags = merge(
    local.settings.tags_common
  )

  metadata_options = {
    http_tokens = "required"
  }

  tags = merge(
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )

}
