terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "shared"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::197654287720:role/OrganizationAccountAccessRole"
  }
}