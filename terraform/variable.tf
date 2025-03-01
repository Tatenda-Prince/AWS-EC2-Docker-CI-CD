variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "The name of the key pair"
  default     = "tatendaKeypair"
}


