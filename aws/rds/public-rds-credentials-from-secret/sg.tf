resource "aws_security_group" "rds-sg" {
  name   = "ec2-sg-${local.key_suffix_hyphen}"
  vpc_id = local.settings.vpc_id


  ingress {
    from_port   = local.settings.tcp_port
    to_port     = local.settings.tcp_port
    protocol    = "tcp"
    cidr_blocks = local.settings.inbound_cidrs
    description = "Allowed inbound cidrs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default"
  }

  tags = merge(
    local.settings.tags,
    {
      Name = "net-sg-${local.key_suffix_hyphen}"
    }
  )

  description = "${local.key_suffix_hyphen} RDS SG"
}