# provider.tf
terraform {
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "neuro-terraform"
    key            = "terraform.tfstate"
    encrypt        = true
  }

  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "xenorchestra" {
  url      = var.xo_url
  username = var.xo_username
  password = var.xo_password
  insecure = true
}

provider "aws" {
  region = var.aws_region
}
