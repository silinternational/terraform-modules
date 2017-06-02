/*
 * Create ECS cluster
 */
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.app_env}"
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
resource "random_id" "code" {
  byte_length = 4
}
resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole-${random_id.code.hex}"
  assume_role_policy = "${var.ecsInstanceRoleAssumeRolePolicy}"
}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
  name = "ecsInstanceRolePolicy-${random_id.code.hex}"
  role = "${aws_iam_role.ecsInstanceRole.id}"
  policy = "${var.ecsInstancerolePolicy}"
}

/*
 * Create ECS IAM Service Role and Policy
 */
resource "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole-${random_id.code.hex}"
  assume_role_policy = "${var.ecsServiceRoleAssumeRolePolicy}"
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name = "ecsServiceRolePolicy-${random_id.code.hex}"
  role = "${aws_iam_role.ecsServiceRole.id}"
  policy = "${var.ecsServiceRolePolicy}"
}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile-${random_id.code.hex}"
  role = "${aws_iam_role.ecsInstanceRole.name}"
}
