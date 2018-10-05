resource "aws_route53_zone" "main" {
  name = "${var.route53_domain_name}"
}
resource "aws_route53_record" "domain" {
   name = "${var.route53_domain_name}"
   zone_id = "${aws_route53_zone.main.zone_id}"
   type = "A"
   alias {
     name = "${var.route53_domain_alias_name}"
     zone_id = "${aws_route53_zone.main.zone_id}"
     evaluate_target_health = false
   }
}
output "route53_domain" {
  value = "${aws_route53_record.root_domain.fqdn}"
}
