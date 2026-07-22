terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state stored in S3 with native S3 locking.
  # S3 native locking uses a lock file stored directly in the S3 bucket,
  # eliminating the need for a separate DynamoDB table while still
  # preventing concurrent runs from corrupting the state file.
  # Requires Terraform 1.10 or above and an S3 bucket with versioning enabled.
  # Replace bucket, region, and profile with your own values.
  backend "s3" {
    bucket       = "sadgwryhhg"
    key          = "startupco-security/terraform.tfstate"
    region       = "af-south-1"
    use_lockfile = true
    encrypt      = true
    profile      = "Stewie-Personal"
  }
}

# Replace region and profile with your own values.
provider "aws" {
  region  = "af-south-1"
  profile = "Stewie-Personal"
}
