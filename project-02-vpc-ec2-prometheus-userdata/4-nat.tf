resource "aws_eip" "terra-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "terra-ngw" {
  #  vpc_id        = aws_vpc.terra-vpc.id
  allocation_id = aws_eip.terra-eip.id
  subnet_id     = aws_subnet.terra-public-subnet-1.id

  tags = {
    Name = "terra-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terra-igw]
}

resource "aws_route_table" "terra-private-rt1" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terra-ngw.id
  }
  tags = {
    Name = "terra-private-rt1"
  }
}

resource "aws_route_table_association" "terra-private-rta" {
  subnet_id      = aws_subnet.terra-private-subnet-1.id
  route_table_id = aws_route_table.terra-private-rt1.id
}
