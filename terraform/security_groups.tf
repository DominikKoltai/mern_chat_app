resource "aws_security_group" "bastion_allow_ssh" {
  depends_on = [aws_subnet.chat_app_subnet]
  name       = "bastion-allow-ssh"
  vpc_id     = aws_vpc.chat_app_vpc.id

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
    Name = "bastion-allow-ssh"
  }
}

resource "aws_security_group" "private_ssh" {
  name   = "private-ssh"
  vpc_id = aws_vpc.chat_app_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_allow_ssh.id]
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_allow_ssh.id]
  }
  ingress { 
   		from_port   = 8080 
        to_port     = 8080
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
    Name = "private-ssh"
  }
}