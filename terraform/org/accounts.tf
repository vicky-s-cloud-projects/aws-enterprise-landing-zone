#resource "aws_organizations_organization" "org" {
#  feature_set = "ALL"
#
#  enabled_policy_types = [
#    "SERVICE_CONTROL_POLICY"
#  ]
#}

data "aws_organizations_organization" "org" {}


resource "aws_organizations_account" "shared" {
  name  = "shared-services"
  email = "vivekchalla246+shared@gmail.com"
}

#resource "aws_organizations_account" "workloads" {
#  name  = "workloads"
#  email = "vivekchalla246+workloads@gmail.com"
#}

