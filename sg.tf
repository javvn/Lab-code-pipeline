
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                     = local.sg.name
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = local.sg.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = local.sg.egress_with_cidr_blocks

  tags = local.sg.tags

  depends_on = [
    module.vpc
  ]
}