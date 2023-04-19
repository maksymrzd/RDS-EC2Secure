data "aws_availability_zones" "zones" {}

resource "aws_vpc" "mainvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "main-igw"
  }
}

#------------------------------------------------------------------------------

resource "aws_subnet" "publics" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = element(var.public_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-subnets-route"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.publics[*].id)
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.publics[count.index].id
}

#------------------------------------------------------------------------------

resource "aws_subnet" "privates" {
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = element(var.private_cidrs, count.index)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "private-subnets-route"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.privates[*].id)
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.privates[count.index].id
}



resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-private-subnet-group"
  subnet_ids = [aws_subnet.privates[0].id, aws_subnet.privates[1].id,]
}