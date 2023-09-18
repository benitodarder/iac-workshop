data "aws_ami" "ec2_ami_base" {

  most_recent = true
  owners      = local.settings.instance.ami_owners

  filter {
    name = local.settings.instance.ami_filter_by

    values = local.settings.instance.ami_filters
  }
}
