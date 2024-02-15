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
