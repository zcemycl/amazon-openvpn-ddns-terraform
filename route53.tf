data "aws_route53_zone" "this" {
  name = var.domain
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 60
  records = [aws_instance.this.public_ip]

  lifecycle {
    ignore_changes = all
  }
}
