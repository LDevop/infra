data "aws_route53_zone" "r53_zone" {
  name         = "pupkinsite.boloto.com."
  private_zone = false
}

resource "aws_route53_record" "dns" {
  zone_id = data.aws_route53_zone.r53_zone.zone_id
  name    = "www.${data.aws_route53_zone.r53_zone.name}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
  }
}