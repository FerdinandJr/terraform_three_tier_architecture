resource "aws_instance" "bastion" {
  instance_type               = var.instance_type
  ami                         = var.ami_id
  subnet_id                   = var.pub_sub_1a_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = {
    Name = "Bastion Host"
  }
}