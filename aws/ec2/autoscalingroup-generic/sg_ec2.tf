resource "aws_security_group" "instance" {

  vpc_id = local.settings.vpc_id


  dynamic "ingress" {
    for_each = { for index, record in local.settings.nlb_target_groups : index => record }
    content {
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.sg_protocol
      security_groups = [aws_security_group.nlb.id]
      description     = lookup(ingress.value, "description", "")
    }
  }

  dynamic "ingress" {
    for_each = { for index, record in local.settings.instance_security_groups : index => record }
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = lookup(ingress.value, "security_groups", null)
      cidr_blocks     = lookup(ingress.value, "inbound_cidrs", null)
      prefix_list_ids = lookup(ingress.value, "prefix_list_ids", null)
      description     = lookup(ingress.value, "description", "")
    }
  }

  dynamic "ingress" {
    for_each = { for index, record in local.settings.alb_target_groups : index => record }
    content {
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.sg_protocol
      security_groups = [aws_security_group.alb.id]
      description     = lookup(ingress.value, "description", "")
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

  description = "EC2 Instance base security group"

}
