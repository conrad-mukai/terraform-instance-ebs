/*
 * instance-ebs modules
 */

module "server-hostname" {
  source = "github.com/conrad-mukai/terraform-hostname.git"
  count = "${local.num_hosts}"
  addresses = "${aws_instance.server.*.private_ip}"
  fqdns = "${aws_route53_record.a.*.fqdn}"
  user = "${var.user}"
  private_key_path = "${var.private_key_path}"
  bastion = "${var.bastion}"
  bastion_user = "${var.bastion_user}"
  bastion_private_key_path = "${var.bastion_private_key_path}"
}
