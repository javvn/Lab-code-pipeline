locals {
  common_tags = {
    Env       = "dev"
    Terraform = true
    Project   = "Lab-code-pipeline"
    Owner     = "jawn"
  }

  vpc = {
    name                    = "${lower(local.common_tags.Project)}-vpc"
    cidr                    = "10.0.0.0/16"
    azs                     = ["us-east-1a", "us-east-1b"]
    private_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets          = ["10.0.101.0/24", "10.0.102.0/24"]
    enable_nat_gateway      = false
    enable_vpn_gateway      = false
    single_nat_gateway      = false
    map_public_ip_on_launch = true
    create_igw              = true
    vpc_tags                = merge(local.common_tags, { Name = "${lower(local.common_tags.Project)}-vpc" })
    private_subnet_tags     = merge(local.common_tags, { Name = "${lower(local.common_tags.Project)}-private" })
    public_subnet_tags      = merge(local.common_tags, { Name = "${lower(local.common_tags.Project)}-public" })
  }

  sg = {
    name        = "${lower(local.common_tags.Project)}-sg"
    description = "Security Group for ${local.common_tags.Project}"

    ingress_with_cidr_blocks = [
      {
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        cidr_blocks = "0.0.0.0/0"
        description = "ssh ports"
      },
      {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = "0.0.0.0/0"
        description = "http ports"
      },
      {
        protocol    = "tcp"
        from_port   = 3000
        to_port     = 3000
        cidr_blocks = "0.0.0.0/0"
        description = "node ports"
      },
      {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = "0.0.0.0/0"
        description = "https ports"
      }
    ]
    egress_with_cidr_blocks = [
      {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = "0.0.0.0/0"
        description = "Allow to communicate to the Internet."
      }
    ]

    tags = merge(local.common_tags, { Name = "${lower(local.common_tags.Project)}-sg" })
  }

  ec2 = {
    name       = "${lower(local.common_tags.Project)}-ec2"
    type       = "t2.micro"
    key_name   = "jawn"
    monitoring = false
    subnet_id  = module.vpc.public_subnets[0]
    user_data  = file("${path.module}/scripts/userdata.sh")

    vpc_security_group_ids = [module.sg.security_group_id]
  }

  ec2_ami = {
    name               = "${lower(local.common_tags.Project)}-ami"
    source_instance_id = module.ec2.id
    tags = merge(local.common_tags, {
      Name = "${lower(local.common_tags.Project)}-ami"
    })
  }

  launch_template = {
    name                    = "${local.ec2.name}-launch-templete"
    instance_type           = local.ec2.type
    key_name                = local.ec2.key_name
    disable_api_stop        = false
    disable_api_termination = false
  }

  alb = {
    name                       = "${lower(local.common_tags.Project)}-lb"
    internal                   = false
    load_balancer_type         = "application"
    ip_address_type            = "ipv4"
    subnets                    = module.vpc.public_subnets
    enable_deletion_protection = false
    security_groups            = [module.sg.security_group_id]

    tags = merge(local.common_tags, {
      Name = "${lower(local.common_tags.Project)}-lb"
    })
  }

  lb_target_group = {
    name                          = "${lower(local.common_tags.Project)}-lb-tg"
    port                          = 3000
    protocol                      = "HTTP"
    protocol_version              = "HTTP1"
    vpc_id                        = module.vpc.vpc_id
    target_type                   = "instance"
    load_balancing_algorithm_type = "round_robin"
    tags                          = merge(local.common_tags, { Name = "${lower(local.common_tags.Project)}-lb-tg" })
  }

  lb_listener = {
    load_balancer_arn = aws_alb.this.arn
    port              = 3000
    protocal          = "HTTP"
    ssl_policy        = ""
    default_action = {
      type             = "forward"
      target_group_arn = aws_lb_target_group.this.arn
    }
    tags = merge(local.common_tags, { Name = "${lower(local.common_tags.Project)}-lb-listener" })
  }
}