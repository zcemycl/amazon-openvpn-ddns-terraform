resource "aws_instance" "this" {
  ami                         = var.openvpn_server_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = var.subnet_id
  security_groups             = [module.security_groups.sg_ids["openvpn"].id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.this.name
  user_data = templatefile("./setup.sh", {
    admin_password = var.admin_pwd
    email          = var.email
    domain         = var.domain
    subdomain      = "${var.subdomain}.${var.domain}"
  })
}