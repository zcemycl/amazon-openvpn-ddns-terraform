provider "aws" {
  region = var.AWS_REGION
}

# network
data "aws_availability_zones" "this" {
  state = "available"
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
  availability_zone                           = element(data.aws_availability_zones.this.names, count.index)
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
}

resource "aws_route_table_association" "this" {
  count          = length(var.alb_subnets_cidr)
  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = aws_route_table.this.id
}


# store key
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_uuid" "uuid" {}

resource "aws_s3_bucket" "this_creds" {
  bucket        = "${var.AWS_REGION}-${random_uuid.uuid.result}"
  force_destroy = true
}


resource "aws_s3_object" "this_openvpn_public" {
  bucket  = aws_s3_bucket.this_creds.id
  key     = "openvpn/public_key.pem"
  content = tls_private_key.this.public_key_openssh
}

resource "aws_s3_object" "this_openvpn_private" {
  bucket  = aws_s3_bucket.this_creds.id
  key     = "openvpn/private_key.pem"
  content = tls_private_key.this.private_key_pem
}

# vpn server
module "openvpn" {
  source             = "github.com/zcemycl/amazon-openvpn-ddns"
  AWS_REGION         = var.AWS_REGION
  vpc_id             = aws_vpc.this.id
  prefix             = var.prefix
  openvpn_server_ami = lookup(var.OPENVPN_SERVER_AMI, var.AWS_REGION)
  subnet_id          = aws_subnet.this[0].id
  instance_type      = "t2.small"
  admin_pwd          = var.ADMIN_PWD
  email              = var.email
  subdomain          = var.SUBDOMAIN
  domain             = var.domain
  public_key_openssh = tls_private_key.this.public_key_openssh
}
