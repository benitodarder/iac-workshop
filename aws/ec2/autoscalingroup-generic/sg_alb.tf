resource "aws_security_group" "alb" {

  vpc_id = local.settings.vpc_id

  dynamic "ingress" {
    for_each = { for index, record in local.settings.alb_listeners : index => record }
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.sg_protocol
      cidr_blocks = ingress.value.inbound_cidrs
    }
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
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )

  lifecycle {
    create_before_destroy = true
  }

  description = "EC2 ALB based security group"

}
