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
    name = "jwt_token"
    type = "S"
  }
  attribute {
    name = "access_token"
    type = "S"
  }
  attribute {
    name = "refresh_token"
    type = "S"
  }
  attribute {
    name = "last_logout"
    type = "S"
  }
  attribute {
    name = "last_login"
    type = "S"
  }
  attribute {
    name = "login_status"
    type = "N"
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
    hash_key           = "jwt_token"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "AccessTokenIndex"
    hash_key           = "access_token"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "RefreshTokenIndex"
    hash_key           = "refresh_token"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "LastLogoutIndex"
    hash_key           = "last_logout"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
  global_secondary_index {
    name               = "LastLoginIndex"
    hash_key           = "last_login"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
  global_secondary_index {
    name               = "LoginStatus"
    hash_key           = "login_status"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
}

