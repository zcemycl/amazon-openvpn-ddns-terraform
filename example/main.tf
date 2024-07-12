provider "aws" {
  region = var.AWS_REGION
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw"
  }
}

# public
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_subnet" "this" {
  count                                       = length(var.alb_subnets_cidr)
  vpc_id                                      = aws_vpc.this.id
  cidr_block                                  = element(var.alb_subnets_cidr, count.index)
  availability_zone                           = element(var.availability_zones, count.index)
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
}

resource "aws_route_table_association" "this" {
  count          = length(var.alb_subnets_cidr)
  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = aws_route_table.this.id
}



resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.this.private_key_pem}' > private_key.pem"
  }
}

module "openvpn" {
  source             = "github.com/zcemycl/amazon-openvpn-ddns"
  AWS_REGION         = var.AWS_REGION
  vpc_id             = aws_vpc.this.id
  prefix             = var.prefix
  openvpn_server_ami = var.OPENVPN_SERVER_AMI
  subnet_id          = aws_subnet.this[0].id
  instance_type      = "t2.small"
  admin_pwd          = var.ADMIN_PWD
  email              = var.email
  subdomain          = var.SUBDOMAIN
  domain             = var.domain
  public_key_openssh = tls_private_key.this.public_key_openssh
}
