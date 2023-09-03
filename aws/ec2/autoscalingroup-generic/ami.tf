data "aws_ami" "ec2_ami_base" {

  most_recent = true
  owners      = local.settings.ami_owners

  filter {
    name = local.settings.ami_filter_by

    values = local.settings.ami_filters
  }
}