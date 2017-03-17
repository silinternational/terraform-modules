/*
 * Create ECS cluster
 */
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tag_app_name}-${var.tag_app_env}"
}

/*
 * Deterimine most recent ECS optimized AMI
 */
data "aws_ami" "ecs_ami"{
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

/*
 * Create ECS IAM Instance Role and Policy
 */
resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"
  assume_role_policy = "${var.ecsInstanceRoleAssumeRolePolicy}"
}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
  name = "ecsInstanceRolePolicy"
  role = "${aws_iam_role.ecsInstanceRole.id}"
  policy = "${var.ecsInstancerolePolicy}"
}

/*
 * Create ECS IAM Service Role and Policy
 */
/*resource "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole"
  assume_role_policy = "${var.ecsServiceRoleAssumeRolePolicy}"
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name = "ecsServiceRolePolicy"
  role = "${aws_iam_role.ecsServiceRole.id}"
  policy = "${var.ecsServiceRolePolicy}"
}*/

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile"
  roles = ["${aws_iam_role.ecsInstanceRole.name}"]
}
