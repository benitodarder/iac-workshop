output "aws_subnet_private_ids" {
  value = [for subnet in aws_subnet.this : subnet.id]
}

output "aws_subnet_private_cidr_blocks" {
  value = [for subnet in aws_subnet.this : subnet.cidr_block]

}

output "aws_subnet_private_tag_names" {
  value = [for subnet in aws_subnet.this : subnet.tags["Name"]]
}
