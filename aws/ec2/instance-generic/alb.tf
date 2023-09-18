resource "aws_lb" "alb" {

  count = length(local.settings.alb.listeners) > 0 ? 1 : 0

  load_balancer_type = "application"
  internal           = false
  subnets            = local.settings.alb.subnets
  security_groups    = [aws_security_group.alb.id]

  enable_cross_zone_load_balancing = true


  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )
}



resource "aws_lb_listener_rule" "alb" {

  for_each = { for index, record in local.settings.alb.listener_rules : index => record }

  listener_arn = aws_lb_listener.alb[each.value.listener_index].arn
  priority     = each.value.priority


  dynamic "action" {

    for_each = each.value.actions_forward_to_target_group
    content {
      type             = action.value.type
      target_group_arn = aws_lb_target_group.alb[action.value.target_group_index].arn
    }
  }

  dynamic "condition" {
    for_each = each.value.conditions_by_path
    content {
      path_pattern {
        values = condition.value.paths
      }
    }
  }


}

resource "aws_lb_target_group_attachment" "alb" {

  for_each = { for index, record in local.settings.alb.target_groups : index => record }

  target_group_arn = aws_lb_target_group.alb[each.key].arn
  target_id        = module.ec2-instance-base.id
  port             = each.value.port
}

resource "aws_lb_listener" "alb" {

  for_each = { for index, record in local.settings.alb.listeners : index => record }


  load_balancer_arn = aws_lb.alb[0].arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = lookup(each.value, "ssl_policy", null)
  certificate_arn   = lookup(each.value, "certificate_arn", null)

  dynamic "default_action" {

    for_each = each.value.actions
    content {
      type = default_action.value.type

      dynamic "redirect" {
        for_each = lookup(default_action.value, "redirect", [])
        content {
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          status_code = lookup(redirect.value, "status_code", null)
        }
      }

      dynamic "fixed_response" {
        for_each = lookup(default_action.value, "fixed_response", [])
        content {
          content_type = lookup(fixed_response.value, "content_type", null)
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }

    }
  }


  depends_on = [
    aws_lb.alb
  ]

}

