resource "aws_lb" "nlb" {

  count = length(local.settings.nlb.configurations) > 0 ? 1 : 0

  load_balancer_type = "network"
  internal           = false
  subnets            = local.settings.nlb.subnets
  security_groups    = [aws_security_group.nlb.id]

  enable_cross_zone_load_balancing = true

  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )
}



resource "aws_lb_listener" "nlb" {

  for_each = { for index, record in local.settings.nlb.configurations : index => record }

  load_balancer_arn = aws_lb.nlb[0].arn

  protocol = each.value.protocol
  port     = each.value.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb[each.value.target_group_index].arn
  }
}

resource "aws_lb_target_group_attachment" "nlb" {

  for_each = { for index, record in local.settings.nlb.target_groups : index => record }

  target_group_arn = aws_lb_target_group.nlb[each.key].arn
  target_id        = module.ec2-instance-base.id
  port             = each.value.port
}
