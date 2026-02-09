resource "aws_sns_topic" "cloudtrail_alerts" {
  name              = "cloudtrail-alerts"
  kms_master_key_id = aws_kms_key.cloudtrail.arn
}

resource "aws_cloudtrail" "org_trail" {
  name           = "organization-trail"
  s3_bucket_name = aws_s3_bucket.central_logs.id

  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  kms_key_id = aws_kms_key.cloudtrail.arn

  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logs_role.arn

  sns_topic_name = aws_sns_topic.cloudtrail_alerts.name
}

resource "aws_kms_key" "cloudtrail" {
  description             = "KMS key for CloudTrail logs"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRootAccount"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}


resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/organization"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.cloudtrail.arn
}


resource "aws_iam_role" "cloudtrail_logs_role" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_logs_policy" {
  role = aws_iam_role.cloudtrail_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
    }]
  })
}

