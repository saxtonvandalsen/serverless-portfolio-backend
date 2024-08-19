# Cloud Resume Challenge - AWS (Backend)

Adhering closely to the challenge guidelines, I established a secondary repository specifically for the backend infrastructure, where the Terraform configuration manages all my AWS resources.

My thought process was to create a robust and scalable backend architecture, ensuring each component is properly configured and version-controlled. This repository includes the following AWS resources within my Terraform configuration:
* **AWS S3 Bucket & Object**
* **AWS Lambda Function URL**
* **AWS DynamoDB**
* **AWS CloudFront**
* **AWS IAM Policies**

All these resources are defined within my "main.tf" file. Whenever I push changes to GitHub, my CI/CD pipeline, configured with GitHub Actions, automatically applies the Terraform configuration, this ensures for seamless deployment and updates to my infrastructure.

Here's the link back to my [frontend repository](https://github.com/saxtonvandalsen/cloud-resume-challenge).