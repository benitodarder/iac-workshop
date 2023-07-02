data "aws_iam_instance_profile" "instance_base" {
  name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.instance_name}"

  depends_on = [
    module.iam_role_ec2
  ]
}

data "aws_ami" "ec2_ami_base" {
  most_recent = true
  owners      = local.settings.ami_owners

  filter {
    name = local.settings.ami_filter_by

    values = local.settings.ami_filters
  }
}

data "template_file" "cloudinit_provisioner" {
  template = file("./assets/cloud-init.yaml.tpl")

  vars = {
    region = local.settings.tags_common.region
  }
}

module "ec2-instance-base" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2"

  name = local.settings.instance_name

  ami                    = data.aws_ami.ec2_ami_base.id
  instance_type          = local.settings.instance_type
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.base.id]
  subnet_id              = local.settings.subnet_id_private
  iam_instance_profile   = data.aws_iam_instance_profile.instance_base.name
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
    local.settings.tags_common,
    local.settings.tags_common
  )

  metadata_options = {
    http_tokens = "required"
  }

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.instance_name}"
    }
  )

}
