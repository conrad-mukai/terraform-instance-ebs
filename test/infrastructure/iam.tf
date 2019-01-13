/*
 * instance-ebs IAM role
 */

data "aws_iam_policy_document" "ebsave-assume" {
  "statement" {
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ebsave" {
  name = "ebsave-role"
  description = "role for ebsave"
  assume_role_policy = "${data.aws_iam_policy_document.ebsave-assume.json}"
}

data "aws_iam_policy_document" "ebsave" {
  "statement" {
    sid = "backup"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:CreateTags",
      "ec2:CreateSnapshot"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ebsave" {
  policy = "${data.aws_iam_policy_document.ebsave.json}"
  role = "${aws_iam_role.ebsave.id}"
}

resource "aws_iam_instance_profile" "ebsave" {
  name = "ebsave"
  role = "${aws_iam_role.ebsave.name}"
}
