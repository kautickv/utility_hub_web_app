# Create an s3 Bucket to store the zip files to upload to lambda
module "lambda_zip_s3_bucket"{
    source = "../../modules/s3"
    bucket_name = "${var.domain_name}-backend-code-s3-bucket"
    force_destroy = true
}

# Create another s3 Bucket to store json_viewer projects and json objects
module "json_viewer_s3_bucket"{
    source = "../../modules/s3"
    bucket_name = "${var.app_name}-json-viewer-feature"
    force_destroy = true
}