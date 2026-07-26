import {
  to = aws_iam_policy.enforce_mfa
  id = "arn:aws:iam::104783764104:policy/Force-MFA"
}

import {
  to = aws_iam_group_policy_attachment.developers_ec2
  id = "Developers/arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

import {
  to = aws_iam_group_policy_attachment.developers_s3
  id = "Developers/arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

import {
  to = aws_iam_group_policy_attachment.developers_cloudwatch
  id = "Developers/arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

import {
  to = aws_iam_group_policy_attachment.operations_ec2
  id = "Operations/arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

import {
  to = aws_iam_group_policy_attachment.operations_cloudwatch
  id = "Operations/arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

import {
  to = aws_iam_group_policy_attachment.operations_ssm
  id = "Operations/arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

import {
  to = aws_iam_group_policy_attachment.operations_rds
  id = "Operations/arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

import {
  to = aws_iam_group_policy_attachment.finance_billing
  id = "Finance/arn:aws:iam::aws:policy/job-function/Billing"
}

import {
  to = aws_iam_group_policy_attachment.finance_readonly
  id = "Finance/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

import {
  to = aws_iam_group_policy_attachment.analysts_s3_readonly
  id = "Data-Analysts/arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

import {
  to = aws_iam_group_policy_attachment.analysts_rds_readonly
  id = "Data-Analysts/arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}
