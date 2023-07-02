resource "aws_security_group" "base" {
  name   = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.instance_name}"
  vpc_id = local.settings.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.settings.inbound_ssh_cidrs
    description = "Allow SSH to selected CIDRs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default"
  }

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.instance_name}"
    },
  )

  description = "EC2 Instance base security group"

}
