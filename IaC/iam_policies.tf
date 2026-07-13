
# -----------------------------------------------------------------------------
# MFA Enforcement Policy
# Forces all IAM users to set up MFA before they can perform any action
# in AWS. Without this, a user with stolen credentials could immediately
# abuse their permissions with no second factor required.
#
# Two statements are required:
#   1. AllowMFASelfManagement — lets users set up their own MFA device
#      on first login, even before MFA is active on their account.
#   2. DenyAllWithoutMFA — blocks all other actions if MFA is not present.
#
# BoolIfExists is used instead of Bool to also catch cases where the MFA
# key is absent entirely (e.g. programmatic access without MFA).
# -----------------------------------------------------------------------------

resource "aws_iam_policy" "enforce_mfa" {
  name        = "Enforce-MFA-All-Users"
  description = "Denies all AWS actions unless the user has authenticated with MFA."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowMFASelfManagement"
        Effect = "Allow"
        Action = [
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ResyncMFADevice",
          "iam:ChangePassword"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid    = "DenyAllWithoutMFA"
        Effect = "Deny"
        Action = "*"
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Attach the MFA enforcement policy to all groups so every user is covered.
resource "aws_iam_group_policy_attachment" "developers_mfa" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.enforce_mfa.arn
}

resource "aws_iam_group_policy_attachment" "operations_mfa" {
  group      = aws_iam_group.operations.name
  policy_arn = aws_iam_policy.enforce_mfa.arn
}

resource "aws_iam_group_policy_attachment" "finance_mfa" {
  group      = aws_iam_group.finance.name
  policy_arn = aws_iam_policy.enforce_mfa.arn
}

resource "aws_iam_group_policy_attachment" "data_analysts_mfa" {
  group      = aws_iam_group.data_analysts.name
  policy_arn = aws_iam_policy.enforce_mfa.arn
}
