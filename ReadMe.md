Important info:

1. This is the present working directory in github actions:
    /home/runner/work/password_generator_webapp/password_generator_webapp

2. Run terraform like that. Unable to add it to environment variables
    C:\Users\kautick.vaisnavsing\Desktop\Software\Terraform\terraform.exe --version


# Team Communication Web Tool

The Team Communication Web Tool is a platform designed to facilitate effective and efficient communication among team members. It allows users to share text and image updates with their entire team, enabling collaboration, knowledge sharing, and transparency. The tool aims to streamline communication processes, ensuring that important information reaches the right people at the right time.

## Features

- **User Registration and Authentication:** Users can create individual accounts with unique login credentials. User authentication ensures secure access to the web tool.
- **Newsfeed:** The primary interface for users to view and share updates. Updates are displayed in reverse chronological order, with the most recent at the top. Users can filter updates by date or specific topics.
- **Text Updates:** Users can compose and post text updates to share information, announcements, or progress reports. Updates can be formatted using basic styling options (e.g., bold, italic, bullet points). Users can comment on and react to text updates to foster discussions and provide feedback.
- **Image Updates:** Users can upload images to accompany their updates, enhancing visual communication. The web tool should support popular image formats and provide basic image editing capabilities (e.g., cropping, resizing).
- **Search and Filtering:** Users can search for specific updates using keywords, authors, or dates. Advanced filtering options allow users to narrow down updates based on various criteria (e.g., team, tags, importance).
- **Tags and Categorization:** Users can assign tags to updates to categorize them based on topics, projects, or other relevant classifications. Tags help users quickly find updates related to specific subjects.

## Architecture

The project utilizes the following AWS services for its infrastructure:

- **AWS Lambda:** The backend logic of the web tool is implemented using AWS Lambda functions. These serverless functions handle user authentication, newsfeed retrieval, text and image update posting, and other necessary functionalities.
- **API Gateway:** AWS API Gateway creates RESTful APIs for the frontend application to interact with the Lambda functions. It handles request routing, authentication, and rate limiting.
- **DynamoDB:** The NoSQL database provided by AWS, DynamoDB, stores user account information, updates, comments, reactions, and other relevant data. It offers fast and scalable performance for handling large volumes of data.
- **S3:** Amazon S3 is used to host the React application and store the uploaded images. It provides high availability and durability, ensuring that the web tool remains accessible and the images are securely stored.

## Deployment

The project follows a continuous integration and deployment approach. The source code is stored in this GitHub repository, and the deployment pipeline is set up using GitHub Actions. When a pull request is merged into the master branch, GitHub Actions triggers the necessary steps to deploy the updated application and infrastructure.

Infrastructure provisioning is managed using Terraform. The Terraform configuration files define and provision all the required AWS resources, including Lambda functions, API Gateway, DynamoDB tables, and S3 buckets.


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
