resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_sg_id]

  tags = {
    Name = "Bastion-Server"
  }
}
