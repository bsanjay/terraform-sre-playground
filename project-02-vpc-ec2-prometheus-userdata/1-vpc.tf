resource "aws_vpc" "terra-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terra-vpc"
  }
}
