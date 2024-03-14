data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  count                   = var.Subnet_Count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.cidr_offset, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-EKS-subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"  
  }

  tags = {
    Name = "${var.project_name}-EKS-rt"
  }
}

resource "aws_route_table_association" "subnet_1" {
  count = var.Subnet_Count
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}