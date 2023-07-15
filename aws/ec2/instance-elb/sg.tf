resource "aws_security_group" "instance" {

  # name   = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
  vpc_id = local.settings.vpc_id

  dynamic "ingress" {
    for_each = { for index, record in local.settings.listening_ports_protocols : index => record }
    content {
      from_port   = ingress.value.instance_port
      to_port     = ingress.value.instance_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.inbound_cidrs_instance
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

resource "aws_security_group" "elb" {

  # name   = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
  vpc_id = local.settings.vpc_id

  dynamic "ingress" {
    for_each = { for index, record in local.settings.listening_ports_protocols : index => record }
    content {
      from_port   = ingress.value.lb_port
      to_port     = ingress.value.lb_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.inbound_cidrs_elb
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

