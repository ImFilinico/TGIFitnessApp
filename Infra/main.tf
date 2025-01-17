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
    Id      = "CloudFrontTGIPolicy"
    Statement = [
      {
        Sid       = "AllowCloudFrontOAI"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.tgifitness-bucket.arn}/*"
      }
    ]
  })
}

locals {
  s3_origin_id = "tgifitness-s3-origin"
}

#####################################################################################

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-access-control"
  description                       = "OAC for accessing S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "tgifitness_distribution" {
    origin {
        domain_name = aws_s3_bucket.tgifitness-bucket.bucket_regional_domain_name
        origin_id = local.s3_origin_id

        s3_origin_config {
          origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
        }
    }

    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    default_cache_behavior {
      allowed_methods = ["GET", "HEAD"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = local.s3_origin_id

      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }
      viewer_protocol_policy = "redirect-to-https"
      min_ttl = 0
      default_ttl = 3600
      max_ttl = 86400
    }

    price_class = "PriceClass_100"

    viewer_certificate {
      cloudfront_default_certificate = true
    }

    restrictions {
      geo_restriction {
        restriction_type = "whitelist"
        locations = ["US", "CA"]
      }
    }

    tags = {
        project = "TGIFitness"
    }

}

#####################################################################################

resource "aws_cognito_user_pool" "trainer_pool"{
  name = "trainer"
}
