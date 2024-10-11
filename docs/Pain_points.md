# Pain Points and Resolutions in Project Infrastructure Setup

This document describes the pain points experienced while building the project infrastructure, the challenges encountered, and the steps taken to resolve them.

---

## Pain Point 1: Securing S3 Bucket Access for CloudFront Distribution

### The Problem

As part of the project infrastructure, a **React** application is hosted in an **S3 bucket**, and **CloudFront** is used as the Content Delivery Network (CDN) to serve the application globally with low latency. A common pattern for this setup is to make the **S3 bucket public**, allowing CloudFront to fetch the static assets (such as React files) without access issues. However, this introduces significant security risks:

- **Public S3 Bucket Exposure**: Making an S3 bucket public triggers security vulnerabilities, as the bucket is exposed to anyone with the link. This can lead to unintended data exposure.
- **Security Alerts**: Some internal security engineers raised concerns that leaving the S3 bucket public would trigger alerts in our security monitoring tools. This is considered a violation of best practices, and an alternative solution needed to be implemented.

### The Solution

To resolve this, **CloudFront Origin Access Identity (OAI)** was implemented. The OAI acts as a virtual identity that CloudFront uses to access the objects in the S3 bucket without making the bucket publicly accessible.

The approach allows **CloudFront** to read from the **S3 bucket** while ensuring that the bucket remains **private**. This mitigates the security risk and eliminates any alerts from leaving the bucket exposed.

### Steps Taken

1. **Created a CloudFront Origin Access Identity (OAI)**:
   - This OAI is linked to CloudFront and acts as a trusted entity that can access the S3 bucket.

2. **Restricted S3 Bucket Access to Only CloudFront**:
   - Instead of making the bucket public, a **bucket policy** was attached to allow only the CloudFront OAI to access the bucket. All other public access to the S3 bucket was blocked.

### Terraform Code Implementation

The following Terraform code illustrates how we implemented the solution:

```hcl
# Create a Cloudfront Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "static_hosting_oai" {
  comment = "${var.app_name} - Access identity for static hosting"
}

# Create an S3 bucket policy to allow only CloudFront read access
data "aws_iam_policy_document" "s3_allow_cloudfront_access" {
  statement {
    sid = "AllowCloudfrontAccess"
    effect = "Allow"
    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.static_hosting_oai.s3_canonical_user_id]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${module.s3_static_hosting.bucket_arn}/*"
    ]
  }
}

# Assign the above policy to the S3 static hosting bucket
resource "aws_s3_bucket_policy" "s3_allow_public_access" {
  bucket = module.s3_static_hosting.bucket_id
  policy = data.aws_iam_policy_document.s3_allow_cloudfront_access.json
}


## Pain Point 2: Conditional Lambda Deployment with Custom VPC

### The Problem

A common design pattern when invoking backend **Lambda functions** from **API Gateway** is to create the required resources in the default AWS VPC. However, for increased security, compliance, and isolation within a corporate environment, I decided to deploy all Lambda functions within a **custom VPC** with 3 **public subnets** and 3 **private subnets** spanning multiple availability zones within a region.

Deploying the Lambdas inside a custom VPC improves security by:
- Ensuring better **network isolation**.
- Controlling **network access** for Lambda functions.
- **Adhering to compliance** standards.

However, setting up this environment requires additional resources such as:
- **Route tables**.
- **Internet Gateways**.
- **NAT Gateways** (for private subnets to access the internet).

The problem arose due to the cost of running these additional resources (especially NAT gateways). While the enhanced security of a custom VPC is necessary for some environments, there may be times when the budget is constrained, and using the **default AWS VPC** would suffice.

### The Challenge

I needed a **flexible deployment** that allowed the option to:
- Deploy the Lambda functions within a **custom VPC** when security is prioritized and the cost is justified.
- Deploy the Lambda functions to the **default AWS VPC** when cost is a concern.

### The Solution

To address this, I created a Terraform deployment that uses a boolean flag (`use_vpc`) to conditionally:
- Set up the VPC and its components (subnets, route tables, Internet Gateway, NAT Gateway, etc.) when `use_vpc = true`.
- Skip VPC creation and deploy directly in the default AWS VPC when `use_vpc = false`.

To achieve this:
1. **Conditional Resource Creation**: I used Terraform's **`count`** feature to conditionally create or skip resources based on the `use_vpc` flag.
2. **Lifecycle Block for Lambda Recreation**: I implemented the **lifecycle block** in Terraform to force Lambda re-creation whenever its configuration changes. This prevents issues with configuration synchronization between **`terraform plan`** and **`terraform apply`**.

### Terraform Code Implementation

Below is the relevant Terraform code:

```hcl
# Conditionally create VPC setup module based on use_vpc flag
module "setup_vpc_network" {
    count    = var.use_vpc ? 1 : 0
    source   = "../../modules/vpc_setup"
    app_name = var.app_name
    region   = var.region
}

# Lambda definition with lifecycle block to handle recreation on config changes
resource "aws_lambda_function" "lamda_function" {
  function_name = var.function_name

  s3_bucket = var.s3_bucket_id
  s3_key    = var.s3_bucket_key

  runtime = "python3.9"
  handler = var.handler_name
  source_code_hash = var.source_code_hash
  role = var.role_arn
  layers = var.layers_arn
  environment {
    variables = var.environment_variables
  }
  timeout = var.timeout
  memory_size = var.memory_size

  # Conditional VPC Configuration
  dynamic "vpc_config" {
    for_each = var.use_vpc ? [1] : []
    content {
      subnet_ids         = var.private_subnets
      security_group_ids = [var.vpc_lambda_security_group]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
