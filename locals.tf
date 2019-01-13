/*
 * instance-ebs local variables
 */

locals {
  num_hosts = "${var.instances_per_subnet * length(var.subnet_ids)}"
  device_names = "${keys(var.volume_map)}"
  num_devices = "${length(local.device_names)}"
  num_volumes = "${local.num_hosts * local.num_devices}"
  devices = "${join(" ", local.device_names)}"
  mount_volume_script = "${file("${path.module}/scripts/mount-volumes.sh")}"
  private_key = "${file(var.private_key_path)}"
  bastion_private_key = "${file(var.bastion_private_key_path)}"
  num_backups = "${var.disable_backup ? 0 : local.num_hosts}"
}
