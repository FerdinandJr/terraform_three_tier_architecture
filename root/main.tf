#configure aws provider
provider "aws" {
  region = var.region
}


#create vpc
module "vpc" {
  source                      = "../modules/vpc"
  region                      = var.region
  vpc_cidr                    = var.vpc_cidr
  project_name                = var.project_name
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
  private_db_subnet_az1_cidr  = var.private_db_subnet_az1_cidr
  private_db_subnet_az2_cidr  = var.private_db_subnet_az2_cidr
}

module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id

}

module "ec2" {
  source                 = "../modules/ec2"
  ec2_security_groups    = module.security-group.ec2_security_groups
  public_subnet_az1_cidr_id = module.vpc.public_subnet_az1_cidr_id
}

