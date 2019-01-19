/*
 * instance-ebs outputs
 */

output "instance_ids" {
  value = "${aws_instance.server.*.id}"
}

output "dns_records" {
  value = "${aws_route53_record.a.*.fqdn}"
}
