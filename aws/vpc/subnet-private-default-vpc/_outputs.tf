output "aws_subnet_private_tag_name" {
  value = lookup(aws_subnet.private.tags, "Name")
}

output "aws_subnet_private_id" {
  value = aws_subnet.private.id
}

output "aws_subnet_private_cidr_block" {
  value = aws_subnet.private.cidr_block
}

