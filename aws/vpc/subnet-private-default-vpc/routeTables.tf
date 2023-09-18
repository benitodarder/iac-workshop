resource "aws_route_table" "to_public_nat" {


  vpc_id = aws_default_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public.id
  }
  tags = merge(
    local.settings.tags_common,
    local.settings.tags_common,
    {
      "Name" = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.detail.hex)}"
    }
  )
}

resource "aws_route_table_association" "to_public_nat" {

  count = length(local.settings.subnets)

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.to_public_nat.id
}
