resource "aws_route_table" "main_private" {


  vpc_id = local.settings.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private.id
  }
  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}"
    }
  )
}

resource "aws_route_table_association" "main_private" {

  subnet_id      = aws_subnet.main_private.id
  route_table_id = aws_route_table.main_private.id
}
