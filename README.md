# EC2 Instances with EBS Volumes

This module creates EC2 instances with attached EBS volumes. The EBS volumes
persist between occurences of the EC2 instances. A cronjob that manages backups
of the EBS volumes is set up on each instance.

## AMI Requirements

There are minimum requirements for the AMIs that this module supports. These
are:
* Python 2.7
* OpenSSL 1.0 or higher (needed for TLS 1.2)
* Access to XFS (the xfsprogs package can be installed)

This module has been validated with AMIs of the following flavors:
* Amazon Linux
* Amazon Linux 2
* SUSE 15
* Ubuntu 18
* Ubuntu 14
* RHEL 7
* Centos 7

The following AMIs did not support this module:
* SUSE 11
* RHEL 6
* Centos 6

## Structure

The module is passed a list of subnets in which to deploy. It will create
`instances_per_subnet` instances in each subnet. The ordering of the instances
is significant since lists of volumes must be in the same availability zone as
their assigned instance. Instances are placed in subnets as follows:

    for i in (0 .. n * m)
        instance[i] -> subnet[i % n]

where `n` is the number of subnets and `m` is `instances_per_subnet`.

The module is also passed 2 maps `mount_map` and `volume_map`.  The first maps
attachment devices to mount points. The second maps attachment devices to lists
of volume IDs. The list should provide a volume ID for each instance being
created, in the same order as described above. If the volumes are created with
the [terraform-ebs-volume](https://github.com/conrad-mukai/terraform-ebs-volume)
module and the subnets are created with the
[terraform-network](https://github.com/conrad-mukai/terraform-network) module
with the same availability zone lists, then the order of the volumes in the
`terraform-ebs-volume` output will match the order of the instances in this
module.

## Backup

By default the [ebsave](https://github.com/conrad-mukai/python-ebsave) Python
script is installed and scheduled to run in a cronjob. This will take a daily
snapshot. The script will maintain a 7 day retention period for snapshots. The
backup can be disabled by setting the `disable_backup` flag to true.

## Input Variables

| Name | Description | Default |
| ---- | ----------- | ------- |
| `ami` | instance AMI | |
| `app` | app to use in tags | |
| `bastion` | bastion public IP or DNS | |
| `bastion_private_key_path` | local path to bastion private key | |
| `bastion_user` | bastion default user | |
| `disable_backup` | disable backup | false |
| `iam_instance_profile` | IAM instance profile | "" |
| `instance_type` | instance type | |
| `instances_per_subnet` | number of instances per subnet | 1 |
| `key_name` | key pair name | |
| `mount_map` | map of mount points {device=mount_point} | |
| `name` | name to use in tags | |
| `private_key_path` | local path to the shared private key | |
| `route53_ttl` | Route53 record TTL | 300 |
| `route53_zone_id` | Route53 zone ID | |
| `security_group_ids` | list of security groups | |
| `subnet_ids` | list of subnets | |
| `user` | default user for AMI | |
| `volume_map` | map of volume IDs {device=[volume_ids]} | |

## Outputs

| Name | Description |
| ---- | ----------- |
| `instance_ids` | IDs of launched instances |
