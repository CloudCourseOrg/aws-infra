provider "aws" {
  region  = var.region
  profile = var.env
}

module "vpc_configuration" {
  source = "./modules/vpcConfiguration"

  cidr_block              = var.vpc_cidr_block
  instance_tenancy        = var.vpc_instance_tenancy
  subnet_count            = var.subnet_count
  bits                    = var.subnet_bits
  vpc_name                = var.vpc_name
  internet_gateway_name   = var.vpc_internet_gateway_name
  public_subnet_name      = var.vpc_public_subnet_name
  public_routetable_name  = var.vpc_public_routetable_name
  private_subnet_name     = var.vpc_private_subnet_name
  private_routetable_name = var.vpc_private_routetable_name
}
