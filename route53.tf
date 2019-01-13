/*
 * instance-ebs Route53 resources
 */

resource "aws_route53_record" "a" {
  count = "${aws_instance.server.count}"
  name = "${lookup(aws_instance.server.*.tags[count.index], "Name")}"
  type = "A"
  ttl = "${var.route53_ttl}"
  zone_id = "${var.route53_zone_id}"
  records = ["${aws_instance.server.*.private_ip[count.index]}"]
}
