resource "aws_iam_policy" "code_commmit_full" {
  name        = "CodeCommitFullAccess"
  description = "Code commit full access policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["codecommit:*"],
        "Resource" : "arn:aws:codecommit:*"
      }
    ]
  })

  tags = local.common_tags

  //  depends_on = [
  //
  //  ]
}

//resource "aws_iam_user_policy" "user" {
//
//  depends_on = [
//    aws_iam_user.user
//  ]
//}
//
//resource "aws_iam_group_policy_attachment" "user" {
//  group = var.group
//  policy_arn = ""
//
//  depends_on = [
//    aws_iam_group.dev,
//    aws_iam_policy.code_commmit_full
//  ]
//}


//resource "aws_iam_user_policy" "code_commit" {
//  name = "CodeCommitFullAccess"
//  user = aws_iam_user.user.name
//
//  policy = jsonencode({
//    "Version": "2012-10-17",
//    "Statement": [
//      {
//        "Effect": "Allow",
//        "Action": [
//          "codecommit:*"],
//        "Resource": "*"
//      }
//    ]
//  })
