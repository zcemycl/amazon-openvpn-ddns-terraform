variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "prefix" {
  default = "aws-openvpn"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "alb_subnets_cidr" {
  type = list(string)
  # default = ["10.1.0.0/21", "10.1.8.0/21"]
  default = ["10.1.0.0/21"]
}

variable "OPENVPN_SERVER_AMI" {
  default = {
    "eu-west-2"      = "ami-07d20571c32ba6cdc"
    "us-west-2"      = "ami-0075013580f6322a1"
    "ap-northeast-2" = "ami-056a29f2eddc40520"
    "ap-northeast-1" = "ami-0162fe8bfebb6ea16"
    "eu-central-1"   = "ami-07652eda1fbad7432"
    "eu-west-3"      = "ami-0062b622072515714"
  }
}


variable "domain" {
  type = string
}

variable "SUBDOMAIN" {
  type = string
}

variable "ADMIN_PWD" {
  type = string
}

variable "email" {
  type = string
}