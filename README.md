# GitHubActions AutoDeploy: Dockerized App Deployment on AWS EC2


## Technical Architecture


![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/595eed6bc28aa70ac7c04eb93ae4c44a1f3eda36/img/Screenshot%202025-03-01%20214223.png)


## Project Overview

This project implements a fully automated CI/CD pipeline using GitHub Actions, Docker, AWS EC2, and Terraform. Whenever a developer pushes changes to the repository, GitHub Actions:

Builds a Docker image

Pushes it to Amazon Elastic Container Registry (ECR)

Deploys the updated container to an AWS EC2 instance

Restarts the running container to reflect the latest changes

By integrating Terraform, we ensure a repeatable, scalable, and infrastructure-as-code (IaC) approach for provisioning AWS resources.

## Project Objective

1.Automate application deployment using GitHub Actions & Docker.

2.Ensure reliability with Infrastructure as Code (IaC) via Terraform.

3.Minimize manual intervention by fully automating build, push, and deployment processes.

## Features

1.CI/CD Pipeline: Auto-build & deploy upon code push 

2.Dockerized Deployment: Ensures consistent application runtime 

3.GitHub Actions: Automates the entire workflow

4.AWS ECR: Stores versioned Docker images 

5.AWS EC2 Instance: Hosts & runs the deployed app

6.Terraform: Manages AWS infrastructure as code 


## Technologies Used
1.AWS EC2 – Hosts the Dockerized application.

2.AWS ECR – Stores Docker images.

3.GitHub Actions – Automates the CI/CD pipeline.

4.Docker – Containerizes the application.

5.Terraform – Automates AWS infrastructure setup.

6.Flask – Python web framework for the app.

## Use Case
You work at the Up The Chelsea start-up as a DevOps Engineer you are tasked with automation and deployement of a web app to reduce downtime and improving application reliability to their customers by leveraging GitHub Actions, Docker, EC2 and Terraform. 

## Prerequisites
1.Git & GitHub Account

2.AWS Account with configured IAM roles, EC2, and ECR

3.Terraform & AWS CLI installed (if using Terraform for infrastructure)

4.Docker installed on local machine

## Step 1: Clone the Repository
1.1.Clone this repository to your local machine.

```language
git clone https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd.git
```

## Step 2 : Run Terraform workflow to initialize, validate, plan then apply
2.1.We are going to deploy amazon EC2 instance with security groups and with IAM Role using terraform.

2.2.In your local terraform visual code environment terminal, to initialize the necessary providers, execute the following command in your environment terminal.

```language
terraform init
```
Upon completion of the initialization process, a successful prompt will be displayed, as shown below.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/a866a5e9895d1a9129ae266ebd8f74177530025a/img/Screenshot%202025-03-02%20093458.png)


2.3.Next, let’s ensure that our code does not contain any syntax errors by running the following command 

```language
terraform validate
```

The command should generate a success message, confirming that it is valid, as demonstrated below.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/d7a276e477698a5b5963eb28086f9bb9b83d8280/img/Screenshot%202025-03-02%20093551.png)


2.4.Let’s now execute the following command to generate a list of all the modifications that Terraform will apply. 

```language
terraform plan
```

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/56c7b01cd4ce22bf89703948fe7f319cb79539cd/img/Screenshot%202025-03-02%20093746.png)

The list of changes that Terraform is anticipated to apply to the infrastructure resources should be displayed. The “+” sign indicates what will be added, while the “-” sign indicates what will be removed.

2.5.Now, let’s deploy this infrastructure! Execute the following command to apply the changes and deploy the resources. Note — Make sure to type “yes” to agree to the changes after running this command

```language
terraform apply
```

Terraform will initiate the process of applying all the changes to the infrastructure. Kindly wait for a few seconds for the deployment process to complete.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/3ce92978855e30c46e9e696f11e02673493a365f/img/Screenshot%202025-03-02%20093943.png)


## Success
The process should now conclude with a message indicating “Apply complete”, stating the total number of added, modified, and destroyed resources, accompanied by several resources.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/ab5b8088b7a341842e214ffdc398411a08dca686/img/Screenshot%202025-03-02%20094044.png)


## Step 3: Verify creation of our EC2 Instance
In the AWS Management Console, head to the Amazon EC2 dashboard and verify that the DockerAppServer instance was successfully created with public ip and IAM Role.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/bf4e8fcb14f0185ce94ce80ab767783e5b1889ca/img/Screenshot%202025-03-02%20094320.png)


## Step 4: Lets Push Code to Trigger GitHub Actions
4.1.This action will trigger GitHub Actions to create ecr , build, push, and deploy the latest container to EC2.

```language
git add .
git commit -m "Updated Flask app Homepage"
git push origin main
```

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/ae40b2fa2629a8603b7d0bbb8cc0bd14328b8658/img/Screenshot%202025-03-02%20094857.png)


4.2.Now github actions will build, push, and deploy the latest container to EC2.


## Step 5: Testing
5.1.Verify if the GitHub Actions workflow runs successfully.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/80920699375494ad0a9980745711cae4acb1d2a1/img/Screenshot%202025-03-02%20095042.png)


![image_alt]()


5.2.Verify if the container is running on EC2:

```language
ssh ec2-user@your-ec2-public-ip

docker ps
```

![image_alt]()


5.3.Access the app using `http://<your-ec2-public-ip>:5000`

open your browser and paste the url above with your your-ec2-public-ip you be able to see the app running.

![image_alt]()


## Future Enhancements
1.Add a Load Balancer (ALB) for high availability.

2.Monitor logs & metrics with AWS CloudWatch.


## Congratulations
We have succesfully created DevOps automation with AWS and GitHub Actions. It ensures continuous deployment of a Dockerized application in a scalable, secure, and efficient manner.It is fully automated, scalable, and production-ready CI/CD pipeline using GitHub Actions, Docker, AWS, and Terraform.It's an excellent example of modern DevOps workflows and best practices. 






































