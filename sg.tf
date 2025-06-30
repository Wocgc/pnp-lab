resource "aws_security_group" "cgc-mgmt-sg" {
  name        = "cgc-mgmt-sg"
  description = "Allow ssh"
  vpc_id      = aws_vpc.cgc_pnp_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cgc-mgmt-sg"
  }
}

