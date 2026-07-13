
# -----------------------------------------------------------------------------
# IAM Users
# Individual users are created for each employee.
# Users are assigned to their group, which controls their permissions.
# No permissions are attached directly to users.
# -----------------------------------------------------------------------------

# --- Developers (4 users) ---
resource "aws_iam_user" "developer_01" {
  name = "Developer-01"
}

resource "aws_iam_user" "developer_02" {
  name = "Developer-02"
}

resource "aws_iam_user" "developer_03" {
  name = "Developer-03"
}

resource "aws_iam_user" "developer_04" {
  name = "Developer-04"
}

resource "aws_iam_group_membership" "developers" {
  name  = "developers-group-membership"
  group = aws_iam_group.developers.name
  users = [
    aws_iam_user.developer_01.name,
    aws_iam_user.developer_02.name,
    aws_iam_user.developer_03.name,
    aws_iam_user.developer_04.name,
  ]
}

# --- Operations (2 users) ---
resource "aws_iam_user" "operations_01" {
  name = "Operations-01"
}

resource "aws_iam_user" "operations_02" {
  name = "Operations-02"
}

resource "aws_iam_group_membership" "operations" {
  name  = "operations-group-membership"
  group = aws_iam_group.operations.name
  users = [
    aws_iam_user.operations_01.name,
    aws_iam_user.operations_02.name,
  ]
}

# --- Finance (1 user) ---
resource "aws_iam_user" "finance_01" {
  name = "Finance-01"
}

resource "aws_iam_group_membership" "finance" {
  name  = "finance-group-membership"
  group = aws_iam_group.finance.name
  users = [
    aws_iam_user.finance_01.name,
  ]
}

# --- Data Analysts (3 users) ---
resource "aws_iam_user" "data_analyst_01" {
  name = "Data-Analyst-01"
}

resource "aws_iam_user" "data_analyst_02" {
  name = "Data-Analyst-02"
}

resource "aws_iam_user" "data_analyst_03" {
  name = "Data-Analyst-03"
}

resource "aws_iam_group_membership" "data_analysts" {
  name  = "data-analysts-group-membership"
  group = aws_iam_group.data_analysts.name
  users = [
    aws_iam_user.data_analyst_01.name,
    aws_iam_user.data_analyst_02.name,
    aws_iam_user.data_analyst_03.name,
  ]
}
