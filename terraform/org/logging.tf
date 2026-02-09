# checkov:skip=CKV_AWS_18:Access logging not required for log archive bucket
# checkov:skip=CKV_AWS_144:Cross-region replication handled externally
# checkov:skip=CKV2_AWS_62:Event notifications not required
# checkov:skip=CKV2_AWS_61:Lifecycle managed by log retention policy
# checkov:skip=CKV_AWS_145:Bucket encrypted via CloudTrail KMS key
resource "aws_s3_bucket" "central_logs" {
  provider      = aws.shared
  bucket        = "central-cloudtrail-logs-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_versioning" "logs" {
  provider = aws.shared

  bucket = aws_s3_bucket.central_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  provider = aws.shared

  bucket = aws_s3_bucket.central_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


data "aws_iam_policy_document" "cloudtrail_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.central_logs.arn]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.central_logs.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "AllowManagementAccountRead"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::138973099853:root"]
    }

    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketVersioning",
      "s3:GetBucketPublicAccessBlock",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.central_logs.arn
    ]
  }

}

resource "aws_s3_bucket_policy" "logs" {
  provider = aws.shared

  bucket = aws_s3_bucket.central_logs.id
  policy = data.aws_iam_policy_document.cloudtrail_policy.json


}
