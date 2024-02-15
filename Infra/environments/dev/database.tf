#-------------------------------------------------------------------------------------------
# Create database for multitab feature
module "dev_dynamodb_table" {
  source      = "../../modules/dynamodb"
  name        = "utility_hub_bookmarks_table"
  hash_key    = "email"
  attributes  = [
    { name = "email", type = "S" },
    { name = "config_json", type = "S" },
    { name = "last_modified", type = "S" }
  ]
  global_secondary_indexes = [
    { 
      name            = "ConfigJsonIndex"
      hash_key        = "config_json"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastModified"
      hash_key        = "last_modified"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    }
  ]
}

#-------------------------------------------------------------------------------------------
# Create dynamoDb table for authentication service
#-------------------------------------------------------------------------------------------
# Create database for multitab feature
module "dev_dynamodb_table" {
  source      = "../../modules/dynamodb"
  name        = "utility_hub_authentication_table"
  hash_key    = "email"
  attributes  = [
    { name = "email", type = "S" },
    { name = "first_name", type = "S" },
    { name = "last_name", type = "S" },
    { name = "jwt_token", type = "S" },
    { name = "access_token", type = "S" },
    { name = "refresh_token", type = "S" },
    { name = "last_logout", type = "S" },
    { name = "last_login", type = "S" },
    { name = "login_status", type = "N" }
  ]
  global_secondary_indexes = [
    { 
      name            = "FirstNameIndex"
      hash_key        = "first_name"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastNameIndex"
      hash_key        = "last_name"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "JwtTokenIndex"
      hash_key        = "jwt_token"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "AccessTokenIndex"
      hash_key        = "access_token"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "RefreshTokenIndex"
      hash_key        = "refresh_token"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastLogoutIndex"
      hash_key        = "last_logout"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LastLoginIndex"
      hash_key        = "last_login"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    },
    { 
      name            = "LoginStatus"
      hash_key        = "login_status"
      projection_type = "ALL"
      write_capacity  = 1
      read_capacity   = 1
    }
  ]
}
