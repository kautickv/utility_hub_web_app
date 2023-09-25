resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.app_name}-Lambda-SG"
  }

  # Egress rule to allow outbound traffic on port 443
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.ssm_vpce_sg.id]  # If using VPC endpoints; replace with actual SG IDs
  }
}
