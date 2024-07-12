terraform {
  backend "s3" {
    bucket = "freevpn"
    key    = "production/terraform.tfstate"
    region = "eu-west-2"
  }
}
