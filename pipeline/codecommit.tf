resource "aws_codecommit_repository" "dev" {
  repository_name = "lab-codepipeline"
  description     = "The repository for Lab code pipeline"
}