output "repo" {
  value = {
    id              = aws_codecommit_repository.this.id
    description     = aws_codecommit_repository.this.description
    repository_id   = aws_codecommit_repository.this.repository_id
    repository_name = aws_codecommit_repository.this.repository_name
    clone_url = {
      http = aws_codecommit_repository.this.clone_url_http
      ssh  = aws_codecommit_repository.this.clone_url_ssh
    }
  }

}

output "deploy_app" {
  value = {
    name                = aws_codedeploy_app.this.name
    application_id      = aws_codedeploy_app.this.application_id
    arn                 = aws_codedeploy_app.this.arn
    compute_platform    = aws_codedeploy_app.this.compute_platform
    id                  = aws_codedeploy_app.this.id
    github_account_name = aws_codedeploy_app.this.github_account_name
    linked_to_github    = aws_codedeploy_app.this.linked_to_github
    deployment_group = {
      app_name              = aws_codedeploy_deployment_group.this.app_name
      deployment_group_name = aws_codedeploy_deployment_group.this.deployment_group_name
      ec2_tag               = aws_codedeploy_deployment_group.this.ec2_tag_set
    }
  }
}

output "vpc" {
  value = {
    vpc_name       = module.vpc.name
    vpc_azs        = module.vpc.azs
    vpc_arn        = module.vpc.vpc_arn
    vpc_cidr_block = module.vpc.vpc_cidr_block
    vpc_id         = module.vpc.vpc_id
    default = {
      network_acl_id    = module.vpc.default_network_acl_id
      route_table_id    = module.vpc.default_route_table_id
      security_group_id = module.vpc.default_security_group_id
    }
    igw = {
      arn = module.vpc.igw_arn
      id  = module.vpc.igw_id
    }
    private = {
      route_table_ids     = module.vpc.private_route_table_ids
      subnets             = module.vpc.private_subnets
      subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
    public = {
      route_table_ids     = module.vpc.public_route_table_ids
      subnets             = module.vpc.public_subnets
      subnets_cidr_blocks = module.vpc.public_subnets_cidr_blocks
    }
  }
}

output "security_group" {
  value = module.sg
}

output "ec2" {
  value = {
    arn           = module.ec2.arn
    id            = module.ec2.id
    intance_state = module.ec2.instance_state
    user_data     = local.ec2.user_data
    private_ip    = module.ec2.private_ip
    eip           = aws_eip.ec2.public_ip
    public_ip     = module.ec2.public_ip
  }
}