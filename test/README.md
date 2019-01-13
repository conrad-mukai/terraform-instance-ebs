# EC2 Instances with EBS Volumes Test

Test for instance-ebs module.

## Warning

This test will create instances, EBS volumes, and NAT gateways. All of these
incur cost, so if the test is run remember to destroy the resources shortly
after.

## Quick Start

To run the test do the following:
1. In the infrastructure directory create a `terraform.tfvars` file from
   `terraform.tfvars.template`.
1. Fill in all the empty fields in `terraform.tfvars`. You should set
   `private_key_path` to the path for the private key that corresponds to the
   `key_name` parameter. Set `authorized_key_path` to a personal public key
   (something like `~/.ssh/id_rsa.pub`).
1. Run `terraform init`.
1. Run `terraform apply`.
1. The code will create a VPC and EBS volumes. There are 2 sets of EBS volumes:
   `data` and `log`. Take note of the output.
1. Switch to the instances directory and create a `terraform.tfvars` file from
   `terraform.tfvars.template`.
1. Fill in all the empty fields in `terraform.tfvars` using the outputs from
   the networks run. Use the following:
   * `private_subnet_ids`: `subnet_ids`
   * `internal_security_group_id`: `security_group_ids`
   * `volume_map`: `{"<data-device>" = data_volume_ids, "<log-device>" = log_volume_ids}`
   * `mount_map`: `{"<data-device>" = "/mnt/data", "<log-device>" = "/mnt/log"}`
     where `<data-device>` and `<log-device>` are devices available on the OS (
     typicallly `/dev/xvdf` and `/dev/xvdg` work for this).
1. Run `terraform init`.
1. Run `terraform apply`.
1. The code will create several instances with 2 volumes attached. It will also
   schedule a cronjob to backup the volumes.

## Details

In the infrastructure section, the code determines a list of availability zones
for the specified region and creates a list with half the availabilty zones.
For regions with an odd number of availability zones in half list is rounded up
(so for regions with 3 availability zones the list will contain 2).

Using the availability zone list a network and EBS volumes are created. The
network has the following parameters:

| Variable | Value |
| -------- | ----- |
| `vpc_cidr` | 172.16.0.0/20 |
| `public_cidr_prefix` | 28 |
| `private_cidr_prefix` | 24 |

There are 2 sets of EBS volumes created: data volumes and log volumes. In the
instance section each instance will attach and mount a data and log volume and
set up a cron job that backs up these volumes.

The infrastructure section also creates an IAM role called `ebsave` that is
assigned to each instance. This role gives the backup script permissions to
create EBS snapshots. The cronjob is installed under the non-privileged user
`ebsave`. The output from the cronjob is recorded in
`/var/log/ebsave/ebsave.log`.

## Verification

To verify the test, ssh to any of the instances with the tag `demo-serverXX`.
Since these are created in a private subnet (if you followed the quick start)
you need to access them through the bastion like so:

    ssh -o "ProxyCommand ssh -i <your-bastion-key-path> <bastion-user>@<bastion-host> -W %h:%p" -i <your-private-key-path> <user>@demo-serverXX

Once on the host verify the mounts using `df`. Then check that the crontab is
set up for the user `ebsave`:

    sudo crontab -u ebsave -l

Finally, you can verify that `ebsave` actually runs by running it in dry run
mode:

    ebsave -D -d <data-device> <log-device>

where `<data-device>` and `<log-device>` are the devices you specified in the
`volume_map` and the `mount_map` parameters.
