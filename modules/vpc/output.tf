output "region" {
    value = var.region
}

output "vpc_cidr" {
    value = var.vpc_cidr
}

output "project_name" {
    value = var.project_name
}

output "public_subnet_az1_cidr" {
    value = var.public_subnet_az1_cidr
}

output "public_subnet_az2_cidr" {
    value = var.public_subnet_az2_cidr
}

output "private_app_subnet_az1_cidr" {
    value = var.private_app_subnet_az1_cidr
}

output "private_app_subnet_az2_cidr" {
    value = var.private_app_subnet_az2_cidr
}

output "private_db_subnet_az1_cidr" {
    value = var.private_db_subnet_az1_cidr
}

output "private_db_subnet_az2_cidr" {
    value = var.private_db_subnet_az2_cidr
}

#EC2 and Security Group

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_az1_cidr_id" {
    value = aws_subnet.public_subnet_az1.id
}