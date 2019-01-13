/*
 * instance-ebs provisioners
 */

resource "null_resource" "install-pkgs" {
  count = "${local.num_hosts}"
  triggers {
    instance_id = "${aws_instance.server.*.id[count.index]}"
  }
  connection {
    host = "${aws_instance.server.*.private_ip[count.index]}"
    user = "${var.user}"
    private_key = "${local.private_key}"
    bastion_host = "${var.bastion}"
    bastion_user = "${var.bastion_user}"
    bastion_private_key = "${local.bastion_private_key}"
  }
  provisioner "file" {
    source = "${path.module}/scripts/functions"
    destination = "/tmp/install-pkgs-functions"
  }
  provisioner "file" {
    source = "${path.module}/scripts/install-pkgs.sh"
    destination = "/tmp/install-pkgs.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-pkgs.sh",
      "sudo /tmp/install-pkgs.sh /tmp/install-pkgs-functions ${var.disable_backup ? "false" : "true"}",
      "rm /tmp/install-pkgs.sh /tmp/install-pkgs-functions"
    ]
  }
}

resource "random_integer" "hour" {
  count = "${local.num_backups}"
  max = 23
  min = 0
}

resource "random_integer" "minute" {
  count = "${local.num_backups}"
  max = 59
  min = 0
}

resource "null_resource" "install-ebsave" {
  count = "${local.num_backups}"
  triggers {
    prep_id = "${null_resource.install-pkgs.*.id[count.index]}"
  }
  connection {
    host = "${aws_instance.server.*.private_ip[count.index]}"
    user = "${var.user}"
    private_key = "${local.private_key}"
    bastion_host = "${var.bastion}"
    bastion_user = "${var.bastion_user}"
    bastion_private_key = "${local.bastion_private_key}"
  }
  provisioner "file" {
    source = "${path.module}/files/logrotate"
    destination = "/tmp/logrotate"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/logrotate /etc/logrotate.d/ebsave",
      "sudo chown root:root /etc/logrotate.d/ebsave"
    ]
  }
  provisioner "file" {
    source = "${path.module}/scripts/functions"
    destination = "/tmp/install-ebsave-functions"
  }
  provisioner "file" {
    source = "${path.module}/scripts/install-ebsave.sh"
    destination = "/tmp/install-ebsave.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-ebsave.sh",
      "sudo /tmp/install-ebsave.sh /tmp/install-ebsave-functions \"${random_integer.minute.*.result[count.index]} ${random_integer.hour.*.result[count.index]} * * *\" \"${local.devices}\"",
      "rm /tmp/install-ebsave.sh /tmp/install-ebsave-functions"
    ]
  }
}

resource "null_resource" "mount-volumes" {
  count = "${local.num_volumes}"
  triggers {
    attachment_id = "${aws_volume_attachment.attachment.*.id[count.index]}"
    prep_id = "${element(null_resource.install-pkgs.*.id, count.index)}"
  }
  connection {
    host = "${element(aws_instance.server.*.private_ip, count.index)}"
    user = "${var.user}"
    private_key = "${local.private_key}"
    bastion_host = "${var.bastion}"
    bastion_user = "${var.bastion_user}"
    bastion_private_key = "${local.bastion_private_key}"
  }
  provisioner "file" {
    source = "${path.module}/scripts/functions"
    destination = "/tmp/mount-volumes-functions-${count.index}"
  }
  provisioner "file" {
    content = "${data.template_file.mount-volumes.*.rendered[count.index/local.num_hosts]}"
    destination = "/tmp/mount-volumes-${count.index}.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/mount-volumes-${count.index}.sh",
      "sudo /tmp/mount-volumes-${count.index}.sh /tmp/mount-volumes-functions-${count.index}",
      "rm /tmp/mount-volumes-${count.index}.sh /tmp/mount-volumes-functions-${count.index}"
    ]
  }
}
