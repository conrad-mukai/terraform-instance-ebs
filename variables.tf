/*
 * instance-ebs variables
 */


# tagging

variable "name" {
  type = "string"
  description = "name to use in tags"
}

variable "app" {
  type = "string"
  description = "app to use in tags"
}


# host

variable "ami" {
  type = "string"
  description = "instance AMI"
}

variable "user" {
  type = "string"
  description = "default user for AMI"
}

variable "instance_type" {
  type = "string"
  description = "instance type"
}

variable "key_name" {
  type = "string"
  description = "key pair name"
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  default = ""
}

variable "private_key_path" {
  type = "string"
  description = "local path to the shared private key"
}


# infrastructure

variable "instances_per_subnet" {
  description = "number of instances per subnet"
  default = 1
}

variable "subnet_ids" {
  type = "list"
  description = "list of subnets"
}

variable "security_group_ids" {
  type = "list"
  description = "list of security groups"
}


# volumes

variable "volume_map" {
  type = "map"
  description = "map of volume IDs {device=[volume_ids]}"
}

variable "mount_map" {
  type = "map"
  description = "map of mount points {device=mount_point}"
}


# route53

variable "route53_zone_id" {
  type = "string"
  description = "Route53 zone ID"
}

variable "route53_ttl" {
  description = "Route53 record TTL"
  default = 300
}


# bastion

variable "bastion" {
  type = "string"
  description = "bastion public IP or DNS"
}

variable "bastion_user" {
  type = "string"
  description = "bastion default user"
}

variable "bastion_private_key_path" {
  type = "string"
  description = "local path to bastion private key"
}


# backup

variable "disable_backup" {
  description = "disable backup"
  default = false
}
