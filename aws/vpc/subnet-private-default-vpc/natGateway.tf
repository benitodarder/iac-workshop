resource "aws_nat_gateway" "public" {

  connectivity_type = "public"
  allocation_id     = aws_eip.nat.id
  subnet_id         = local.settings.public_subnet

  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )
}
