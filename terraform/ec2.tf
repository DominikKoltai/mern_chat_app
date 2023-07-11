resource "aws_instance" "jenkins_ec2" {
  ami                    = "ami-0f8e81a3da6e2510a"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.jenkins_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = "chat-app-p-key-pair"

  tags = {
    Name = "jenkins-ec2"
  }
}