module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "6.0.1"
  name            = var.vpc_name
  cidr            = var.cidr_block
  azs             = var.azs
  public_subnets  = var.public_subnets_cidr
  private_subnets = var.private_subnets_cidr

  enable_nat_gateway               = true
  single_nat_gateway               = true
  create_private_nat_gateway_route = true
  public_subnet_tags               = { "Tier" = "public" }
  private_subnet_tags              = { "Tier" = "private" }

  tags = var.tags
}
