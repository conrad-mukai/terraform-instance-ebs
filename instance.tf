/*
 * instance-ebs EC2 instances
 */

resource "aws_instance" "server" {
  count = "${local.num_hosts}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  iam_instance_profile = "${var.iam_instance_profile}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids = "${var.security_group_ids}"
  tags {
    Name = "${var.name}-${var.app}${format("%02d", count.index+1)}"
  }
}
