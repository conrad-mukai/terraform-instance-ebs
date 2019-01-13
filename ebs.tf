/*
 * instance-ebs EBS resources
 */

resource "aws_volume_attachment" "attachment" {
  count = "${local.num_volumes}"
  device_name = "${local.device_names[count.index/local.num_hosts]}"
  instance_id = "${element(aws_instance.server.*.id, count.index)}"
  volume_id = "${element(var.volume_map[local.device_names[count.index/local.num_hosts]], count.index)}"
  skip_destroy = true
}
