/*
 * instance-ebs test
 */

provider "aws" {
  region = "${var.region}"
}

module "instances" {
  source = "../.."
  name = "${var.name}"
  app = "${var.app}"
  ami = "${var.ami}"
  user = "${var.user}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  private_key_path = "${var.private_key_path}"
  iam_instance_profile = "${var.iam_instance_profile}"
  instances_per_subnet = 2
  subnet_ids = "${var.subnet_ids}"
  security_group_ids = "${var.security_group_ids}"
  volume_map = "${var.volume_map}"
  mount_map = "${var.mount_map}"
  route53_zone_id = "${var.route53_zone_id}"
  bastion = "${var.bastion}"
  bastion_user = "${var.bastion_user}"
  bastion_private_key_path = "${var.bastion_private_key_path}"
}
