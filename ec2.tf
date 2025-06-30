resource "aws_instance" "cgc-mgmt-server" {
  ami                         = var.mgmt_ami
  instance_type               = var.mgmt_instance_type
  subnet_id                   = aws_subnet.private_subnet_a.id
  key_name                    = "cgckey"
  vpc_security_group_ids      = [aws_security_group.cgc-mgmt-sg.id]

  tags = {
    Name = "cgc-mgmt-server"
  }
}
