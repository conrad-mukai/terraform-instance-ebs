/*
 * instance-ebs test variables
 */

variable "region" {
  type = "string"
}

variable "name" {
  default = "demo"
}

variable "app" {
  default = "server"
}

variable "ami" {
  type = "string"
}

variable "user" {
  type = "string"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  type = "string"
}

variable "private_key_path" {
  type = "string"
}

variable "iam_instance_profile" {
  default = "ebsave"
}

variable "subnet_ids" {
  type = "list"
}

variable "security_group_ids" {
  type = "list"
}

variable "volume_map" {
  type = "map"
}

variable "mount_map" {
  type = "map"
}

variable "route53_zone_id" {
  type = "string"
}

variable "bastion" {
  type = "string"
}

variable "bastion_user" {
  type = "string"
}

variable "bastion_private_key_path" {
  type = "string"
}
