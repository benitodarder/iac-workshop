resource "aws_dynamodb_table" "backend" {
  name         = "dynamodb-table-${local.key_suffix_hyphen}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}