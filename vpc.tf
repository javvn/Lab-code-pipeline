module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc.name
  cidr = local.vpc.cidr

  azs             = local.vpc.azs
  private_subnets = local.vpc.private_subnets
  public_subnets  = local.vpc.public_subnets

  single_nat_gateway      = local.vpc.single_nat_gateway
  enable_nat_gateway      = local.vpc.enable_nat_gateway
  enable_vpn_gateway      = local.vpc.enable_vpn_gateway
  map_public_ip_on_launch = local.vpc.map_public_ip_on_launch

  create_igw = local.vpc.create_igw

  vpc_tags            = local.vpc.vpc_tags
  private_subnet_tags = local.vpc.private_subnet_tags
  public_subnet_tags  = local.vpc.public_subnet_tags
}