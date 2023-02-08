resource "aws_codecommit_repository" "this" {
  repository_name = lower(local.common_tags.Project)
  description     = "The repository for code pipeline test"
  tags            = merge(local.common_tags, { Name = lower(local.common_tags.Project) })
}