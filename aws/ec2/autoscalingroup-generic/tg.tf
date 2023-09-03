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

  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )

}

resource "aws_lb_target_group" "alb" {

  for_each = { for index, record in local.settings.alb_target_groups : index => record }



  port     = each.value.port
  protocol = each.value.tg_protocol
  vpc_id   = local.settings.vpc_id

  depends_on = [
    aws_lb.alb
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.settings.tags_common,
    {
      Name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    },
  )
}
