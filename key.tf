resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.prefix}-openvpn-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.this.private_key_pem}' > private_key.pem"
  }
}