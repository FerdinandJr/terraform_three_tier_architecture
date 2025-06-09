module "vpc" {
    source = "../modules/vpc"
    region = var.region
    project_name = var.project_name
    vpc_cidr         = var.vpc_cidr
    pub_sub_1a_cidr = var.pub_sub_1a_cidr
    pub_sub_2b_cidr = var.pub_sub_2b_cidr
    pri_sub_3a_cidr = var.pri_sub_3a_cidr
    pri_sub_4b_cidr = var.pri_sub_4b_cidr
    pri_sub_5a_cidr = var.pri_sub_5a_cidr
    pri_sub_6b_cidr = var.pri_sub_6b_cidr
}

module "nat" {
  source = "../modules/nat"
  # pub_sub_1a_id = module.vpc.pub_sub_1a_id
  igw_id        = module.vpc.igw_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
}

module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

# creating Key for instances
module "key" {
  source = "../modules/key"
}

# Creating Application Load balancer
module "alb" {
  source         = "../modules/alb"
  project_name   = module.vpc.project_name
  alb_sg_id      = module.security-group.alb_sg_id
  pub_sub_1a_id  = module.vpc.pub_sub_1a_id
  pub_sub_2b_id  = module.vpc.pub_sub_2b_id
  vpc_id         = module.vpc.vpc_id
}

module "asg" {
  source         = "../modules/asg"
  project_name   = module.vpc.project_name
  key_name       = module.key.key_name
  client_sg_id   = module.security-group.client_sg_id
  pri_sub_3a_id  = module.vpc.pri_sub_3a_id
  pri_sub_4b_id  = module.vpc.pri_sub_4b_id
  tg_arn         = module.alb.tg_arn

}


#data source to look up a secret in AWS Secrets Manager by name.
data "aws_secretsmanager_secret" "rds" {
  name = "rds/mysql/credentials"
}

#This fetches the current version of the secret, including its actual value.
data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}

#This takes the JSON-formatted string stored in Secrets Manager
locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
}

#creating RDS instance

module "rds" {
  source         = "../modules/rds"
  db_sg_id       = module.security-group.db_sg_id
  pri_sub_5a_id  = module.vpc.pri_sub_5a_id
  pri_sub_6b_id  = module.vpc.pri_sub_6b_id
  db_username    = local.db_credentials.username
  db_password    = local.db_credentials.password
}

#create ec2 for bastion host
module "ec2" {
  source = "../modules/ec2"
  pub_sub_1a_id      = module.vpc.pub_sub_1a_id
  bastion_sg_id      = module.security-group.bastion_sg_id
  key_name           = module.key.key_name
}

# create cloudfront distribution 
module "cloudfront" {
  source = "../modules/cloudfront"
  certificate_domain_name = var.certificate_domain_name
  alb_domain_name = module.alb.alb_dns_name
  additional_domain_name = var.additional_domain_name
  project_name = module.vpc.project_name
}


# Add record in route 53 hosted zone

module "route53" {
  source = "../modules/route53"
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id

}
