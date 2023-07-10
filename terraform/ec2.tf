resource "aws_instance" "bastionhost" {
  ami                    = "ami-0f8e81a3da6e2510a"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.chat_app_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_allow_ssh.id]
  key_name               = "chat-app-p-key-pair"

  tags = {
    Name = "bastionhost"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-0f8e81a3da6e2510a"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.chat_app_subnet2.id
  vpc_security_group_ids = [aws_security_group.private_ssh.id]
  key_name               = "chat-app-p-key-pair"

  tags = {
    Name = "jenkins"
  }
}