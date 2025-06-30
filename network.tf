resource "aws_vpc" "cgc_pnp_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "cgc_pnp_vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.cgc_pnp_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.cgc_pnp_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_c"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.cgc_pnp_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "private_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.cgc_pnp_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "private_subnet_c"
  }
}

resource "aws_subnet" "private_subnet_2a" {
  vpc_id            = aws_vpc.cgc_pnp_vpc.id
  cidr_block        = var.private_subnet_2_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "private_subnet_2a"
  }
}

resource "aws_subnet" "private_subnet_2c" {
  vpc_id            = aws_vpc.cgc_pnp_vpc.id
  cidr_block        = var.private_subnet_2_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "private_subnet_2c"
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.cgc_pnp_vpc.id
  cidr_block        = var.private_rds_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "private_rds_a"
  }
}

resource "aws_subnet" "private_db_c" {
  vpc_id            = aws_vpc.cgc_pnp_vpc.id
  cidr_block        = var.private_rds_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "private_rds_c"
  }
}

resource "aws_internet_gateway" "cgc_igw" {
  vpc_id = aws_vpc.cgc_pnp_vpc.id

  tags = {
    Name = "cgc_igw"
  }
}

resource "aws_eip" "eip_for_nat" {
  domain = "vpc"

  tags = {
    Name = "cgc-eip"
}

resource "aws_nat_gateway" "cgc_pnp_nat" {
  allocation_id = aws_eip.eip_for_nat.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "pnp-cgc-nat"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.cgc_pnp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cgc_igw.id
  }

  tags = {
    Name = "public_rtb"
  }
}

resource "aws_route_table_association" "public_as_1" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_as_2" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table" "private_web" {
  vpc_id = aws_vpc.cgc_pnp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cgc_pnp_nat.id
  }

  tags = {
    Name = "private_web"
  }
}

resource "aws_route_table_association" "private_as_1" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_web.id
}

resource "aws_route_table_association" "private_as_2" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_web.id
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.cgc_pnp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cgc_pnp_nat.id
  }

  tags = {
    Name = "private_app"
  }
}

resource "aws_route_table_association" "private_as_3" {
  subnet_id      = aws_subnet.private_subnet_2a.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table_association" "private_as_4" {
  subnet_id      = aws_subnet.private_subnet_2c.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.cgc_pnp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cgc_pnp_nat.id
  }

  tags = {
    Name = "private_db"
  }
}

