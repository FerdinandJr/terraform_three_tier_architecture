variable "instance_type" {
  default = "t2.micro"
}
variable "ami_id" {
  default = "ami-06650ca7ed78ff6fa"
}

variable "ec2_security_groups" {
}

variable "public_subnet_az1_cidr_id" {
}