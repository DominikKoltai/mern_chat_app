resource "aws_eip" "chat_app_e_ip" {
  domain           = "vpc"
  public_ipv4_pool = "amazon"
}

resource "aws_nat_gateway" "chat_app_nat_gateway" {
  depends_on    = [aws_eip.chat_app_e_ip]
  allocation_id = aws_eip.chat_app_e_ip.id
  subnet_id     = aws_subnet.chat_app_subnet.id

  tags = {
    Name = "chat-app-nat-gateway"
  }
}