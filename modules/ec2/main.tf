resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  security_groups =   [var.ec2_security_groups]
  subnet_id = var.public_subnet_az1_cidr_id

  tags = {
    Name = "try ec2"
    }
}