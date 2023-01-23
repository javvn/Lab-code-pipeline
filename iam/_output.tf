output "user_profiles" {
  value       = local.user_profiles
  description = "The user profiles (arn, password, unique_id)"
}

output "code_commit_full_policy" {
  value = aws_iam_policy.code_commmit_full
}

