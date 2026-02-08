#resource "aws_organizations_policy_attachment" "shared_attach" {
#  policy_id = aws_organizations_policy.deny_root.id
#  target_id = aws_organizations_account.shared.id
#
#  depends_on = [
#    aws_organizations_organization.org
#  ]
#}
#
#resource "aws_organizations_policy_attachment" "workloads_attach" {
#  policy_id = aws_organizations_policy.deny_root.id
#  target_id = aws_organizations_account.workloads.id
#}



# Deny Root User Usage

resource "aws_organizations_policy" "deny_root" {
  name        = "deny-root-user"
  description = "Deny all actions by root user"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "DenyRootUser"
      Effect   = "Deny"
      Action   = "*"
      Resource = "*"
      Condition = {
        StringLike = {
          "aws:PrincipalArn" = "arn:aws:iam::*:root"
        }
      }
    }]
  })
}


# Protect CloudTrail

resource "aws_organizations_policy" "protect_cloudtrail" {
  name        = "protect-cloudtrail"
  description = "Prevent CloudTrail deletion or disabling"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ProtectCloudTrail"
      Effect = "Deny"
      Action = [
        "cloudtrail:DeleteTrail",
        "cloudtrail:StopLogging",
        "cloudtrail:UpdateTrail"
      ]
      Resource = "*"
      Condition = {
        StringNotEquals = {
          "aws:PrincipalAccount" = data.aws_organizations_organization.org.master_account_id
        }
      }
    }]
  })
}





# SCP: Protect CloudTrail

#resource "aws_organizations_policy" "protect_cloudtrail" {
#  name = "protect-cloudtrail"
#
#  content = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Effect = "Deny"
#        Action = [
#          "cloudtrail:DeleteTrail",
#          "cloudtrail:StopLogging"
#        ]
#        Resource = "*"
#      }
#    ]
#  })
#
#  type = "SERVICE_CONTROL_POLICY"
#}


# Attach SCPs to Root


resource "aws_organizations_policy_attachment" "deny_root_attach" {
  policy_id = aws_organizations_policy.deny_root.id
  target_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_policy_attachment" "protect_cloudtrail_attach" {
  policy_id = aws_organizations_policy.protect_cloudtrail.id
  target_id = data.aws_organizations_organization.org.roots[0].id
}



