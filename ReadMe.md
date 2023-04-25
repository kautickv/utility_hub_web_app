Steps to set up CICD pipeline on github actions:

1. Create an IAM user on AWS
2. Create an IAM role and assign it to the user. Give the role proper access.
     - There might be two ways to go about this: One way is to create an IAM user and use API Access keys.
       Second way is to create an IAM Role and use trust relationships. (Not sure how this one works)
3. Generate secrets for IAM user and add into Git secrets.
