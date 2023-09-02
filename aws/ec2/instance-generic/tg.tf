resource "aws_lb_target_group" "nlb" {

  for_each = { for index, record in local.settings.nlb_target_groups : index => record }

  port     = each.value.port
  protocol = each.value.tg_protocol
  vpc_id   = local.settings.vpc_id

  depends_on = [
    aws_lb.nlb
  ]

  lifecycle {
    create_before_destroy = true
  }
}
