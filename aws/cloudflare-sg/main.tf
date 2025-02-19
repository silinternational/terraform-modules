
resource "aws_security_group" "cloudflare_https" {
  name        = "cloudflare-https"
  description = "Allow HTTPS traffic from Cloudflare"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "cloudflare" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cloudflare_https.id
  cidr_blocks       = split("\n", trimspace(data.http.cloudflare_ipv4.response_body))
  ipv6_cidr_blocks  = split("\n", trimspace(data.http.cloudflare_ipv6.response_body))
}

moved {
  from = aws_security_group_rule.cloudflare_ipv4
  to   = aws_security_group_rule.cloudflare
}

data "http" "cloudflare_ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}

data "http" "cloudflare_ipv6" {
  url = "https://www.cloudflare.com/ips-v6"
}
