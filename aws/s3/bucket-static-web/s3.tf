data "template_file" "s3_policy" {
  template = file("${path.module}/assets/s3_policy.json.tpl")

  vars = {
    bucket_name = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.suffix.hex)}"
  }
}



resource "aws_s3_bucket" "this" {
  bucket = "${local.settings.tags_common.service_name}-${local.settings.tags_common.service_resource}-${local.settings.tags_common.environment}-${local.settings.tags_common.purpose}-${lower(random_id.suffix.hex)}"
  tags   = local.settings.tags_common
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.template_file.s3_policy.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = local.settings.index
  }

}



resource "aws_s3_object" "this" {

  for_each = { for index, file in local.settings.files : index => file }

  bucket = aws_s3_bucket.this.id
  key    = each.value.key
  source = each.value.filepath

  content_type = each.value.content_type
}

