Steps to set up CICD pipeline on github actions:

1. Create an IAM user on AWS
2. Create an IAM role and assign it to the user. Give the role proper access.
     - There might be two ways to go about this: One way is to create an IAM user and use API Access keys.
       Second way is to create an IAM Role and use trust relationships. (Not sure how this one works)
       Check out this link to setup credentials: https://github.com/marketplace/actions/configure-aws-credentials-for-github-actions
3. Generate secrets for IAM user and add into Git secrets.




Commands:
Sync S3 buclet to local folder
    aws s3 sync --profile <profile name> <local url>  <bucket uri>

Run a cloudformatin stack template
 - This function will create a stack in cloudformation and run the template. Fails if 
