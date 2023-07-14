resource "aws_lb" "network" {
  load_balancer_type = "network"
  internal           = false
  subnets            = local.settings.subnet_id_public

  enable_cross_zone_load_balancing = true

  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )
}

resource "aws_lb_target_group" "this" {

  for_each = { for index, record in local.settings.listening_ports_protocols : index => record }

  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = local.settings.vpc_id

  depends_on = [
    aws_lb.network
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "this" {

  for_each = { for index, record in local.settings.listening_ports_protocols : index => record }

  load_balancer_arn = aws_lb.network.arn

  protocol = each.value.protocol
  port     = each.value.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
}

resource "aws_lb_target_group_attachment" "this" {

  for_each = { for index, record in local.settings.listening_ports_protocols : index => record }

  target_group_arn = aws_lb_target_group.this[each.key].arn
  target_id        = module.ec2-instance-base.id
  port             = each.value.port
}
