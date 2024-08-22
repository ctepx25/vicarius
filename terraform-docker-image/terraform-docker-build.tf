variable "repo_name" {
  description = "ECR repo name"
  type = string 
}

# tell terraform which provider plugins are needed
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

# configure aws provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# create ecr repo
resource "aws_ecr_repository" "ecr-repo" {
  name = "${var.repo_name}"
}

# get authorization credentials to push to ecr
data "aws_ecr_authorization_token" "token" {}

# configure docker provider
provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
      address = data.aws_ecr_authorization_token.token.proxy_endpoint
      username = data.aws_ecr_authorization_token.token.user_name
      password  = data.aws_ecr_authorization_token.token.password
    }
}

# build docker image
resource "docker_image" "app-image" {
  name = "${trim("${data.aws_ecr_authorization_token.token.proxy_endpoint}", "https://")}/${var.repo_name}:latest"
  build {
    context = "../"
  }
  platform = "linux/amd64"
}

# push image to ecr repo
resource "docker_registry_image" "media-handler" {
  name = docker_image.app-image.name
}


output "docker_image" {
  value = docker_image.app-image.name
  
}
