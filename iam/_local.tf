locals {
  common_tags = {
    Env       = "dev"
    Terraform = true
    Project   = "Lab-code-pipeline"
    Owner     = "jawn"
  }

  user_tags  = merge(local.common_tags, { Group = var.group })
  user_names = [for k, v in var.users : v["Name"]]
  user_profiles = { for k, v in var.users : v["Name"] => {
    arn       = aws_iam_user.user[k].arn
    unique_id = aws_iam_user.user[k].unique_id
    role      = aws_iam_user.user[k].tags["Role"]
    password  = aws_iam_user_login_profile.this[k]["password"]
  } }

  code_commit_full_policy_metadata = {
    id        = aws_iam_policy.code_commit_full.id
    arn       = aws_iam_policy.code_commit_full.arn
    name      = aws_iam_policy.code_commit_full.name
    policy_id = aws_iam_policy.code_commit_full.policy_id
    policy    = jsondecode(aws_iam_policy.code_commit_full.policy)
  }

  repo_state = data.terraform_remote_state.repository.outputs.repo
}