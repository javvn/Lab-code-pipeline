output "user_profiles" {
  value       = local.user_profiles
  description = "The user profiles (arn, password, unique_id)"
}

output "code_commit_full_policy" {
  value = local.code_commit_full_policy_metadata
}

output "user_policy_attachment" {
  value = aws_iam_user_policy_attachment.this
}

output "group_policy_attachment" {
  value = aws_iam_group_policy_attachment.this
}