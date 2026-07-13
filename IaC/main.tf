terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state stored in S3 with DynamoDB locking.
  # This is best practice for portfolio and production projects alike —
  # it keeps state off your local machine, prevents corruption from
  # concurrent runs, and makes the setup reproducible by anyone with access.
  
  backend "s3" {
    bucket         = "sadgwryhhg"
    key            = "startupco-security/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "Stewie-Personal"
  }
}

provider "aws" {
  region  = "af-south-1"
  profile = "Stewie-Personal"
}
