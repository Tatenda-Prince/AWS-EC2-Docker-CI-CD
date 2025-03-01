# Security Group for EC2 instance
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow SSH and application access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow app access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "EC2DockerAppRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AmazonEC2ContainerRegistryReadOnly policy
resource "aws_iam_policy_attachment" "ecr_readonly_attach" {
  name       = "ecr-readonly-attach"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach AmazonEC2ContainerServiceforEC2Role policy
resource "aws_iam_policy_attachment" "ecs_service_attach" {
  name       = "ecs-service-attach"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Create an instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2DockerAppInstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instance with IAM Role attached
resource "aws_instance" "app" {
  ami                    = "ami-05b10e08d247fb927"  # Amazon Linux 2 AMI
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = [aws_security_group.app_sg.name]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name  # Attach IAM role

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    service docker start
    usermod -aG docker ec2-user
    chkconfig docker on
  EOF

  tags = {
    Name = "DockerAppServer"
  }
}
