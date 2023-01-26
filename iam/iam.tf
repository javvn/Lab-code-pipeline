################################################
# IAM GROUP
################################################
resource "aws_iam_group" "dev" {
  name = var.group
}

################################################
# IAM USER
################################################
resource "aws_iam_user" "user" {
  count = length(var.users)

  name          = var.users[count.index].Name
  force_destroy = true

  tags = merge(local.user_tags, var.users[count.index])
}

################################################
# IAM ACCESS KEY
################################################
resource "aws_iam_access_key" "this" {
  count = length(var.users)

  user   = var.users[count.index].Name
  status = "Active"

  depends_on = [aws_iam_user.user]
}

################################################
# IAM USER LOGIN PROFILE
################################################
resource "aws_iam_user_login_profile" "this" {
  count = length(var.users)

  user                    = var.users[count.index].Name
  password_reset_required = true

  depends_on = [aws_iam_user.user]
}

################################################
# IAM GROUP MEMBERSHIP
################################################
resource "aws_iam_group_membership" "dev" {
  name  = "dev-user membership"
  users = aws_iam_user.user[*].name
  group = aws_iam_group.dev.name

  depends_on = [
    aws_iam_user.user,
    aws_iam_group.dev
  ]
}