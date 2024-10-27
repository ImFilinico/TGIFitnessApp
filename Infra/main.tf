resource "aws_s3_bucket" "tgifitness-bucket"{
    bucket ="tgifitness-bucket"

    tags ={
        project = "TGIFitness"
    }
}

resource "aws_s3_bucket_ownership_controls" "tgiftiness_bucket_ownership" {
  bucket = aws_s3_bucket.tgifitness-bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "tgifitness_bucket_public_access_block" {
  bucket = aws_s3_bucket.tgifitness-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "tgifitness_bucket_versioning" {
  bucket = aws_s3_bucket.tgifitness-bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.tgifitness-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
    comment = "Origin Access Identity for TGIFitness S3 bucket"
}

resource "aws_s3_bucket_policy" "tgifitness_bucket_policy" {
    bucket = aws_s3_bucket.tgifitness-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.tgifitness-bucket.arn}/*"
        Principal = {
            AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
      }
    ]
  })
}

#####################################################################################

