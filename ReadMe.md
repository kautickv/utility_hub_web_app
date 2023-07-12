>:construction: **STATUS: This project is currently under development.** :construction:
# AWS Serverless Password Generator

This project is a simple web application for generating secure passwords, designed to demonstrate a complete web app development process including front-end, back-end, architecture, and deployment pipeline. It leverages a serverless architecture on AWS and includes features like password generation and storage.

## Features

- Generate random, secure passwords.
- Store generated passwords securely in DynamoDB.
- Interface to retrieve and manage stored passwords.

## Technologies Used
- Frontend: React.js, hosted on AWS S3 and served using AWS CloudFront.
- Backend: AWS Lambda, AWS DynamoDB.
- Infrastructure: AWS API Gateway, Route53, WAF, SSM Parameter Store, Certificate Manager.
- CI/CD: GitHub Actions.
- Infrastructure As Code (IAC): Terraform.

## Architecture Diagram
![Architecture Diagram](documentation/images/architecture_diagram.jpeg)

## Usage
As this is a web application hosted on AWS, there is no installation necessary for the end user. Developers looking to run a local version of the app will need to install Node.js and React.js, and configure AWS CLI with the appropriate permissions.

## Deployment
This project uses GitHub Actions for Continuous Integration/Continuous Deployment (CI/CD) and Terraform for Infrastructure as Code (IaC). New changes can be deployed by creating a new Pull request to the main branch, and commenting "Deploy" in the comment section of the PR
## Getting Started

To set up the project locally, follow these steps:

1. Clone the repository: `git clone <repository-url>`
2. Create an IAM user on AWS.
3. Create an IAM role and assign it to the user. Give the role proper access.
   - There might be two ways to go about this: One way is to create an IAM user and use API Access keys.
     The second way is to create an IAM Role and use trust relationships. (Not sure how this one works)
     Check out this link to set up credentials: [Configure AWS Credentials for GitHub Actions](https://github.com/marketplace/actions/configure-aws-credentials-for-github-actions)
4. Generate secrets for IAM user and add them to Git secrets.
5. Ensure that you have bought a domain name and configured a hosted zone to host the front-end React app.
6. Request an SSL certificate and copy and paste the certificate ARN into the terraform.tfvars file.
7. Create an S3 bucket and update the "0-provider.tf" file with the bucket name. This bucket will store the Terraform states.
   - Key = "dev/passwordGeneratorTerraformState" # Folder structure to determine where to store the state.
8. Update the "terraform.tfvars" file with a chosen domain name for the app (e.g., myapp.example.com).
9. Update the "terraform.tfvars" file with the desired bucket name for React static hosting. Ideally, the bucket name should be the same as the domain name of the app.
10. Update the "terraform.tfvars" file with the SSL_certificate_arn (once requested and approved from certificate manager). Also, update the hosted_zone_id. Obtain these values from the AWS management console.
11. Update the "terraform.tfvars" file with a name of your app. Be careful on the naming limitation. (See description of variable in variables.tf)


For detailed instructions and additional configuration options, please refer to the [documentation](docs/).

## Contributing

We welcome contributions to the Team Communication Web Tool project. To contribute, please follow these guidelines:

1. Fork the repository and create your branch: `git checkout -b my-branch`
2. Commit your changes: `git commit -am 'Add new feature'`
3. Push to the branch: `git push origin my-branch`
4. Submit a pull request

Please ensure that your code adheres to the project's coding standards and includes appropriate tests.

## Acknowledgments

We would like to thank the open-source community for their contributions and the following libraries and frameworks:

- React.js
- AWS SDK
- Terraform
- GitHub Actions

## Contact

For any questions or inquiries, please contact the SOC team.

## Current Issues

1. Every time the Terraform script is applied, a new layer is created irrespective of whether changes have been made to the layer. This can consume a lot of storage and cost money.

2. If the bucket name is changed in the terraform.tfvars file, the Terraform script fails as it tries to look for a bucket with the previous name. Find a way to solve this.

3. Github actions should run on self-hosted servers instead of github provided servers. We need to change the github action script.
