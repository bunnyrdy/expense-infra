terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  
  backend "s3" {
    bucket = "bunny-tf-state"
    key    = "expense-dev-k8-vpc" #we should have unique keys with in the bucket same keys should not be used in the other buckets 
    region = "us-east-1"
    dynamodb_table = "bunny-tf-state"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}