resource "aws_codedeploy_app" "this" {
  name             = lower(local.common_tags.Project)
  compute_platform = "Server"
  tags             = merge(local.common_tags, { Name = lower(local.common_tags.Project) })
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "test"
  service_role_arn      = aws_iam_role.deploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = local.ec2.name
    }
  }

  depends_on = [
    aws_codedeploy_app.this,
    aws_iam_role.deploy
  ]
}