/*
 * instance-ebs templates
 */

data "template_file" "mount-volumes" {
  count = "${local.num_devices}"
  template = "${local.mount_volume_script}"
  vars {
    device_name = "${local.device_names[count.index]}"
    mount_point = "${var.mount_map[local.device_names[count.index]]}"
  }
}
