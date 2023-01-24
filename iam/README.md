# IAM

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.3.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.51.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_group.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.code_commit_full](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_login_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile) | resource |
| [aws_iam_user_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group"></a> [group](#input\_group) | The name of group | `string` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | The list of User data | <pre>list(object({<br>    Name  = string<br>    Group = string<br>    Role  = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_code_commit_full_policy"></a> [code\_commit\_full\_policy](#output\_code\_commit\_full\_policy) | n/a |
| <a name="output_group_policy_attachment"></a> [group\_policy\_attachment](#output\_group\_policy\_attachment) | n/a |
| <a name="output_user_policy_attachment"></a> [user\_policy\_attachment](#output\_user\_policy\_attachment) | n/a |
| <a name="output_user_profiles"></a> [user\_profiles](#output\_user\_profiles) | The user profiles (arn, password, unique\_id) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
