## GitHubActions AutoDeploy: Dockerized App Deployment on AWS EC2


## Technical Architecture


![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/595eed6bc28aa70ac7c04eb93ae4c44a1f3eda36/img/Screenshot%202025-03-01%20214223.png)


## Project Overview

This project implements a fully automated CI/CD pipeline using GitHub Actions, Docker, AWS EC2, and Terraform. Whenever a developer pushes changes to the repository, GitHub Actions:

1.Builds a Docker image

2.Pushes it to Amazon Elastic Container Registry (ECR)

3.Deploys the updated container to an AWS EC2 instance

4.Restarts the running container to reflect the latest changes

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

## Deploy The Application

Before Terraform provisons AWS resources we need to push your application Docker image to ECR:

```language
aws ecr create-repository --repository-name your-repository-name

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <YOUR ACCOUNT ID>.dkr.ecr.us-east-1.amazonaws.com

docker build -t my-flask-app .

docker tag my-node-app:latest <ECR_URI>:latest

docker push <ECR_URI>:latest

```

![image_alt](https://github.com/Tatenda-Prince/AWS-EC2-Docker-CI-CD/blob/d232eadb24a3f9562cf77e36c6e08a130acd0f99/img/Screenshot%202025-03-13%20192442.png)



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

4.1.This GitHub Actions workflow automates the process of building a Docker image, pushing it to AWS Elastic Container Registry (ECR), and deploying it to an Amazon EC2 instance:

1.The workflow is triggered whenever code is pushed to the `master` branch.

2.Builds a new Docker image from the updated code.

3.Pushes the image to AWS ECR

4.Deploys the updated container on EC2, replacing the old one.

GitHub Actions Workflow:

```language

name: Deploy to AWS EC2

on:
  push:
    branches:
      - master  # Runs when you push to the master branch

jobs:
  build-and-push:
    name: Build and Push Docker Image to ECR
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Ensure ECR Repository Exists
      env:
        AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
      run: |
        AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
        REPO_NAME="my-app"

        if ! aws ecr describe-repositories --repository-names $REPO_NAME --region us-east-1 > /dev/null 2>&1; then
          echo "🔹 Repository $REPO_NAME does not exist. Creating it now..."
          aws ecr create-repository --repository-name $REPO_NAME --region us-east-1
          echo "✅ Repository created!"
        else
          echo "✅ Repository $REPO_NAME already exists."
        fi

    - name: Login to AWS ECR
      env:
        AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
      run: |
        AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ECR_URL

    - name: Check if Dockerfile Exists
      run: |
        if [ ! -f app/Dockerfile ]; then
          echo "❌ Dockerfile is missing in ./app!"
          exit 1
        else
          echo "✅ Dockerfile found!"
        fi

    - name: Build and Tag Docker Image
      env:
        AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
      run: |
        AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
        IMAGE_TAG="latest"
        docker build -t my-app -f app/Dockerfile app/.
        docker tag my-app:latest $AWS_ECR_URL/my-app:$IMAGE_TAG

    - name: Push Docker Image to ECR
      env:
        AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
      run: |
        AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
        IMAGE_TAG="latest"
        docker push $AWS_ECR_URL/my-app:$IMAGE_TAG

  deploy:
    needs: build-and-push  # Wait until the image is pushed
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: SSH into EC2 and Deploy
      env:
        SSH_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
        EC2_IP: ${{ secrets.EC2_PUBLIC_IP }}
        AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
      run: |
        # Decode and set up SSH key
        echo "$SSH_KEY" | base64 --decode > private_key.pem
        chmod 400 private_key.pem

        # Connect to EC2 and deploy the container
        ssh -o StrictHostKeyChecking=no -i private_key.pem ec2-user@$EC2_IP << EOF
          set -e  

          echo "🔹 Logging in to AWS ECR..."
          AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
          sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin \$AWS_ECR_URL

          echo "🔹 Pulling the latest image from ECR..."
          IMAGE="\$AWS_ECR_URL/my-app:latest"
          sudo docker pull \$IMAGE

          echo "🔹 Stopping and removing any existing container..."
          sudo docker stop my-app || true
          sudo docker rm my-app || true

          echo "🔹 Removing old images..."
          sudo docker image prune -f

          echo "🔹 Running the new container..."
          sudo docker run -d --restart unless-stopped --name my-app -p 5000:5000 \$IMAGE

          echo "Deployment complete!"

          echo "🔹 Checking if the container is running..."
          if sudo docker ps | grep -q "my-app"; then
            echo "The app is running successfully!"
          else
            echo "The app failed to start!"
            exit 1
          fi
        EOF

```



4.2.Manage Secrets in GitHub:

1.Environment Variables:

The `env` section within the steps that require AWS credentials pulls the values from the secrets stored in the GitHub repository.

2.Navigate to Your Repository on GitHub

3.Add Secrets `Settings > Secrets and variables > Actions`.

4.Add the following secrets:

![image_alt](https://github.com/Tatenda-Prince/AWS-EC2-Docker-CI-CD/blob/53bfb8f558e250dd7993f3db325dcff145fa33e3/img/Screenshot%202025-03-13%20192807.png)



4.3.This action will trigger GitHub Actions to create ecr , build, push, and deploy the latest container to EC2.

```language
git add .
git commit -m "Updated Flask app Homepage"
git push origin main
```

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/ae40b2fa2629a8603b7d0bbb8cc0bd14328b8658/img/Screenshot%202025-03-02%20094857.png)


4.5.Now github actions will build, push, and deploy the latest container to EC2.



## Step 5: Testing
5.1.Verify if the GitHub Actions workflow runs successfully.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/80920699375494ad0a9980745711cae4acb1d2a1/img/Screenshot%202025-03-02%20095042.png)


![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/4579fccd84b1c6e93850d096de2013deea793852/img/Screenshot%202025-03-02%20095056.png)


5.2.Verify if the container is running on EC2:

```language
ssh ec2-user@your-ec2-public-ip

docker ps
```

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/b7c28de6f1c540448c4823e3d299434d072b40e5/img/Screenshot%202025-03-02%20095314.png)


5.3.Access the app using `http://<your-ec2-public-ip>:5000`

open your browser and paste the url above with your your-ec2-public-ip you be able to see the app running.

![image_alt](https://github.com/Tatenda-Prince/aws-ec2-docker-ci-cd/blob/e99cec4e331e0efde242fbae6e34fcb7bec8bcd0/img/Screenshot%202025-03-02%20095651.png)


## Future Enhancements
1.Add a Load Balancer (ALB) for high availability.

2.Monitor logs & metrics with AWS CloudWatch.


## Congratulations
We have succesfully created DevOps automation with AWS and GitHub Actions. It ensures continuous deployment of a Dockerized application in a scalable, secure, and efficient manner.It is fully automated, scalable, and production-ready CI/CD pipeline using GitHub Actions, Docker, AWS, and Terraform.It's an excellent example of modern DevOps workflows and best practices. 






































