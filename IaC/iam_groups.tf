
# -----------------------------------------------------------------------------
# IAM Groups
# Permissions are managed at the group level, not the user level.
# This enforces least privilege and keeps access management scalable.
# -----------------------------------------------------------------------------

# --- Developers ---
resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group_policy_attachment" "developers_ec2" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "developers_s3" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "developers_cloudwatch" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

# --- Operations ---
resource "aws_iam_group" "operations" {
  name = "Operations"
}

resource "aws_iam_group_policy_attachment" "operations_ec2" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "operations_cloudwatch" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_group_policy_attachment" "operations_ssm" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_group_policy_attachment" "operations_rds" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# --- Finance ---
resource "aws_iam_group" "finance" {
  name = "Finance"
}

# Billing covers Cost Explorer and AWS Budgets.
# Requires IAM user access to billing to be enabled in root account settings.
resource "aws_iam_group_policy_attachment" "finance_billing" {
  group      = aws_iam_group.finance.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_group_policy_attachment" "finance_readonly" {
  group      = aws_iam_group.finance.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# --- Data Analysts ---
resource "aws_iam_group" "data_analysts" {
  name = "Data-Analysts"
}

resource "aws_iam_group_policy_attachment" "analysts_s3_readonly" {
  group      = aws_iam_group.data_analysts.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "analysts_rds_readonly" {
  group      = aws_iam_group.data_analysts.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}
