resource "aws_cloudtrail" "org_trail" {
  name                          = "organization-trail"
  s3_bucket_name                = aws_s3_bucket.central_logs.id
  is_organization_trail         = true
  include_global_service_events = true
  enable_logging                = true
}
