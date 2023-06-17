output "aws_dynamodb_table_backend_arn" {
  value = aws_dynamodb_table.backend.arn
}

output "aws_dynamodb_table_backend_name" {
  value = aws_dynamodb_table.backend.name
}

output "aws_s3_bucket_backend_id" {
  value = aws_s3_bucket.backend.id
}

output "aws_s3_bucket_backend_arn" {
  value = aws_s3_bucket.backend.arn
}

