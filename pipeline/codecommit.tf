resource "aws_codecommit_repository" "dev" {
  count = 2

  repository_name = "lab-codepipeline${count.index}"
  description     = "The repository for Lab code pipeline"

  tags = local.common_tags
}
