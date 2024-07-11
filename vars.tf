variable "vpc_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "openvpn_server_ami" {
  type        = string
  description = "any ubuntu ami, it does not need to be specific openvpn server ami"
}

variable "subnet_id" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

variable "admin_pwd" {
  type      = string
  sensitive = true
}

variable "email" {
  type        = string
  description = "Email to register Domain name for ssl certificate"
}

variable "subdomain" {
  type        = string
  description = "xxx.yyy where xxx is subdomain and yyy is domain name, please type xxx value here. "
}

variable "domain" {
  type = string
}

variable "AWS_REGION" {
  type    = string
  default = "eu-west-2"
}