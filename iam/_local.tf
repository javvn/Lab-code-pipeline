locals {
  common_tags = {
    Env       = "dev"
    Terraform = true
    Project   = "Lab-code-pipeline"
    Owner     = "jawn"
  }

  user_tags = merge(local.common_tags, { Group = var.group })

  user_names = [for k, v in var.users : v["Name"]]

  user_profiles = { for k, v in var.users : v["Name"] => {
    arn       = aws_iam_user.user[k].arn
    unique_id = aws_iam_user.user[k].unique_id
    password  = aws_iam_user_login_profile.this[k]["password"]
  } }
}