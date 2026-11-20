# AWS Secret & Access Keys are stored in ~/.aws/credentials using command "aws configure"
# No need to provide explicitly now
provider "aws" {
  region = var.AWS_REGION
}
