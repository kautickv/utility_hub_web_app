output "public_subnets" {
  description = "The public subnets IDs"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
}

output "private_subnets" {
  description = "The private subnets IDs"
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
}

output "vpc_lambda_security_group"{
    description = "Security group for lambda VPC access"
    value = aws_security_group.lambda_sg.id
}

