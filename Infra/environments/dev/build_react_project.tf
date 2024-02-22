# This terraform file will generate .env file and add it inside front_end folder as environment variable
# It will then build the react project
# Then syncs the build folder with the s3 static hosting bucket.

# Create .env and store in front_end folder. Contains API gateway invoke url, s3 website endpoint.
resource "local_file" "react_env_file" {

  depends_on = [aws_api_gateway_stage.utility_hub_api_gateway_stage]
  filename = "../${path.module}/front_end/.env"
  content  = <<-EOF
    REACT_APP_API_GATEWAY_BASE_URL=${aws_api_gateway_stage.utility_hub_api_gateway_stage.invoke_url}
    REACT_APP_BUCKET_HOSTING_ID =${module.s3_static_hosting.bucket_id}
    REACT_APP_S3_WEBSITE_ENDPOINT =${aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint}

    EOF
}

#build the react project and create the /build folder
resource "null_resource" "install_and_build_react_dependencies" {
  
  depends_on = [local_file.react_env_file]
  #Force this block to run every time
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ../${path.module}/front_end/ && npm install && npm ci && npm run build && ls"
  }
}

resource "null_resource" "list_directory" {
  
  depends_on = [local_file.react_env_file]
  #Force this block to run every time
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ../${path.module}/front_end/ && ls -a"
  }
}

# Sync the build folder with the s3 static hosting bucket
resource "null_resource" "sync_build_to_hosting_bucket" {
  
  depends_on = [
    null_resource.install_and_build_react_dependencies
  ]

  #Force this block to run every time
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "aws s3 sync ../${path.module}/front_end/build 's3://${module.s3_static_hosting.bucket_id}'"
  }
}
