data "template_file" "s3_backend_only_ssl_transport" {
  template = file("${path.module}/assets/s3_backend_only_ssl_transport.json")

  vars = {
    bucket_name = "s3-bucket-${local.key_suffix_hyphen}"
  }
}

data "template_file" "s3_backend_policy" {
  template = file("${path.module}/assets/s3_backend_policy.json")

  vars = {
    bucket_name = "s3-bucket-${local.key_suffix_hyphen}"
    account_id  = "${var.account_id}"
  }
}


resource "aws_s3_bucket" "backend" {
  bucket = "s3-bucket-${local.key_suffix_hyphen}"

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "backend_versioning" {
  bucket = aws_s3_bucket.backend.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_policy" "backend_policy" {
  bucket = aws_s3_bucket.backend.id
  policy = data.template_file.s3_backend_policy.rendered
}

resource "aws_s3_bucket_policy" "backend_only_ssl" {
  bucket = aws_s3_bucket.backend.id
  policy = data.template_file.s3_backend_only_ssl_transport.rendered
}


resource "aws_s3_bucket_ownership_controls" "bucket_owner_enforced" {
  bucket = aws_s3_bucket.backend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }


}

resource "aws_s3_bucket_public_access_block" "backend_acls" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
} 