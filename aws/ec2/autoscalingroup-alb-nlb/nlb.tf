resource "aws_lb" "network" {

  load_balancer_type = "network"
  internal           = false
  subnets            = local.settings.subnet_id_public

  enable_cross_zone_load_balancing = true

  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.source.hex)}"
    },
  )
}

resource "aws_lb_target_group" "asg" {

  for_each = { for index, record in local.settings.load_balancer_network_listening_ports : index => record }

  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = local.settings.vpc_id

  depends_on = [
    aws_lb.network
  ]

  lifecycle {
    create_before_destroy = true
  }


  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${each.key}-${lower(random_id.source.hex)}"
    },
  )
}

resource "aws_lb_listener" "asg" {

  for_each = { for index, record in local.settings.load_balancer_network_listening_ports : index => record }

  load_balancer_arn = aws_lb.network.arn

  protocol = each.value.protocol
  port     = each.value.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg[each.key].arn
  }
}


