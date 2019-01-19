/*
 * instance-ebs test outputs
 */

output "instance_ids" {
  value = "${module.instances.instance_ids}"
}

output "dns_records" {
  value = "${module.instances.dns_records}"
}
