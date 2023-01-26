########################################################
# POLICY - CHANGE PASSWORD FOR ALL USER
########################################################
resource "aws_iam_user_policy" "change_password" {
  for_each = local.user_profiles

  name = "ChangePassword"
  user = each.key

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow"
        "Action" : [
          "iam:ChangePassword",
          "iam:GetAccountPasswordPolicy"
        ],
        "Resource" : each.value["arn"]
      }
    ]
  })

  depends_on = [
    aws_iam_user.user,
    aws_iam_access_key.this,
    aws_iam_user_login_profile.this
  ]
}

########################################################
# POLICY - CODE COMMIT FULL FOR LEADER
########################################################
resource "aws_iam_policy" "code_commit_full" {
  name        = "CodeCommitFullAccess"
  description = "Code commit full access policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["codecommit:ListRepositories"],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["codecommit:GetRepository"],
        "Resource" : local.repo_state["arn"]
      }
    ]
  })

  tags = local.common_tags

  depends_on = [
    data.terraform_remote_state.repository
  ]
}

########################################################
# POLICY GROUP ATTACHMENT
########################################################
resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.code_commit_full.arn

  depends_on = [
    aws_iam_group.dev,
    aws_iam_policy.code_commit_full
  ]
}

########################################################
# POLICY USER ATTACHMENT
########################################################
resource "aws_iam_user_policy_attachment" "this" {
  user       = "john"
  policy_arn = aws_iam_policy.code_commit_full.arn

  depends_on = [
    aws_iam_user.user,
    aws_iam_policy.code_commit_full
  ]
}
