resource "aws_s3_bucket" "public_bad" {
  bucket = "bad-public-bucket-demo-${random_id.suffix.hex}"
  acl    = "public-read"
}
