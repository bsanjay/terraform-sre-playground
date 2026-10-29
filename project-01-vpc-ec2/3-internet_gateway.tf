resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terra-vpc.id

  tags = {
    Name = "terra-igw"
  }
}


resource "aws_route_table" "terra-rt-public" {
  vpc_id = aws_vpc.terra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }


  tags = {
    Name = "terra-rt-public"
  }
}


resource "aws_route_table_association" "terra-rta-public" {
  subnet_id      = aws_subnet.terra-public-subnet-1.id
  route_table_id = aws_route_table.terra-rt-public.id
}
