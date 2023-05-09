# Create the dynamoDb table. 
resource "aws_dynamodb_table" "product_table" {
  name         = "Users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"
  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "first_name"
    type = "S"
  }
  attribute {
    name = "last_name"
    type = "S"
  }
  attribute {
    name = "jwtToken"
    type = "S"
  }
  attribute {
    name = "lastLogout"
    type = "S"
  }
}