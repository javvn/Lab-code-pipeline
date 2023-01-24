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
        "Resource" : "arn:aws:codecommit:ap-northeast-2:369463259913:lab-codepipeline1"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.code_commit_full.arn

  depends_on = [
    aws_iam_group.dev,
    aws_iam_policy.code_commit_full
  ]
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = "john"
  policy_arn = aws_iam_policy.code_commit_full.arn

  depends_on = [
    aws_iam_user.user,
    aws_iam_policy.code_commit_full
  ]
}
