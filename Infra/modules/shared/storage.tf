# Create an s3 Bucket to store the zip files to upload to lambda
module "lambda_zip_s3_bucket"{
    source = "../../modules/s3"
    bucket_name = "${var.app_name}-lambda-python-backend-code-s3-bucket"
    force_destroy = true
}