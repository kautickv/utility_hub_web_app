resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.app_name}-Lambda-SG"
  }

  # Egress rule to allow outbound traffic on port 443
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
