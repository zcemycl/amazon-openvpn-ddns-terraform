resource "aws_key_pair" "this" {
  key_name   = "${var.prefix}-openvpn-key"
  public_key = var.public_key_openssh
}
