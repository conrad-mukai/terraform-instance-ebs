/*
 * ebs-instance test infrastructure outputs
 */

output "network" {
  value = {
    vpc_id = "${module.network.vpc_id}"
    public_subnet_ids = "${module.network.public_subnet_ids}"
    private_subnet_ids = "${module.network.private_subnet_ids}"
    nat_ips = "${module.network.nat_ips}"
    public_route_table_id = "${module.network.public_route_table_id}"
    private_route_table_ids = "${module.network.private_route_table_ids}"
    web_security_group_id = "${module.network.web_security_group_id}"
    internal_security_group_id = "${module.network.internal_security_group_id}"
    route53_zone_id = "${module.network.route53_zone_id}"
    bastion_ips = "${module.network.bastion_ips}"
  }
}

output "log_volume_ids" {
  value = "${module.log-volumes.volume_ids}"
}

output "data_volume_ids" {
  value = "${module.data-volumes.volume_ids}"
}

output "iam_instance_profile" {
  value = "${aws_iam_instance_profile.ebsave.name}"
}
