output "account_id" {
  value = var.account_id
}

output "user_profiles" {
  value       = local.user_profiles
  description = "The user profiles (arn, password, unique_id)"
}

output "code_commit_full_policy" {
  value       = local.code_commit_full_policy_metadata
  description = "The code commit full policy"
}

output "user_policy_attachment" {
  value = aws_iam_user_policy_attachment.this
}

output "group_policy_attachment" {
  value = aws_iam_group_policy_attachment.this
}

output "repo_state" {
  value = data.terraform_remote_state.repository
}