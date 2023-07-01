resource "aws_nat_gateway" "private" {

  connectivity_type = "private"
  subnet_id         = aws_subnet.main_private.id

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}"
    }
  )
}
