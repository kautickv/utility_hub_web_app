# Create the dynamoDb table. 
resource "aws_dynamodb_table" "sign_in_user_table" {
  name         = "${var.app_name}_SignIn_table"
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
  global_secondary_index {
    name               = "FirstNameIndex"
    hash_key           = "first_name"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "LastNameIndex"
    hash_key           = "last_name"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "JwtTokenIndex"
    hash_key           = "jwtToken"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "LastLogoutIndex"
    hash_key           = "lastLogout"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
}

