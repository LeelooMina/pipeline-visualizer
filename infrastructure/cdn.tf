locals {
  cdn_url = "${var.environment}.${local.domain_name}"
}

resource "aws_s3_bucket" "webapp_bucket" {
  bucket = "${local.env_prefix}-webapp"

  tags = {
    Name = "Webapp Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "webapp_bucket_ownership" {
  bucket = aws_s3_bucket.webapp_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "webapp_bucket_acl" {
  bucket     = aws_s3_bucket.webapp_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.webapp_bucket_ownership]
}

resource "aws_s3_bucket_public_access_block" "webapp_bucket_block" {
  bucket = aws_s3_bucket.webapp_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "webapp_config" {
  bucket        = aws_s3_bucket.webapp_bucket.bucket
  key           = "webconfig.json"
  cache_control = "max-age=0"
  content       = templatefile("${path.module}/webconfig.json.tpl", { api_url = "https://${local.api_url}", auth_domain = local.auth_domain, auth_client_id = local.auth_client_id })
}

resource "aws_s3_bucket_policy" "cdn_access_policy" {
  bucket = aws_s3_bucket.webapp_bucket.id
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
      {
          "Sid": "AllowCloudFrontServicePrincipal",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudfront.amazonaws.com"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${local.env_prefix}-webapp/*",
          "Condition": {
              "StringEquals": {
                "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
              }
          }
      }
  ]
}
EOF
}

locals {
  s3_origin_id = "${local.env_prefix}-S3Origin"
}

resource "aws_s3_bucket" "cdn_log_bucket" {
  bucket = "${local.env_prefix}-cdn-logs"

  tags = {
    Name = "CDN Bucket Logs"
  }
}

resource "aws_s3_bucket_policy" "cdn_log_access_policy" {
  bucket = aws_s3_bucket.cdn_log_bucket.id
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontLogs",
  "Statement": [
      {
          "Sid": "AllowCloudFrontServicePrincipal",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudfront.amazonaws.com"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${local.env_prefix}-cdn-logs/*",
          "Condition": {
              "StringEquals": {
                "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
              }
          }
      }
  ]
}
EOF
}

resource "aws_s3_bucket_ownership_controls" "cdn_log_bucket_ownership" {
  bucket = aws_s3_bucket.cdn_log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "cdn_log_bucket_block" {
  bucket = aws_s3_bucket.cdn_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "s3_cdn_acl" {
  name                              = "${local.env_prefix}-cdn-acl"
  description                       = "CDN S3 Access Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.webapp_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_cdn_acl.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.namespace} ${var.environment} CDN"
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.cdn_log_bucket.bucket}.s3.amazonaws.com"
    prefix          = local.env_prefix
  }

  aliases = [local.cdn_url]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "index.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "webconfig.json"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 2
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  tags = {
    Name = "Webapp CDN"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.domain_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_route53_record" "record_a" {
  zone_id = data.aws_route53_zone.zone.id
  name    = local.cdn_url
  type    = "A"

  alias {
    name                   = replace(aws_cloudfront_distribution.s3_distribution.domain_name, "/[.]$/", "")
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

output "cdn_web_url" {
  value = local.cdn_url
}
