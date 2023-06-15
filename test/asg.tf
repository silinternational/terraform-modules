module "asg-test" {
  source                  = "../aws/asg"
  app_name                = "test_name1"
  app_env                 = "test_env1"
  ami_id                  = "ami-1234567890"
  aws_instance            = { instance_type = "t3.nano", volume_size = "8", instance_count = "1" }
  private_subnet_ids      = ["1234", "5678"]
  default_sg_id           = "sg-asdf"
  ecs_instance_profile_id = "asdf"
  ecs_cluster_name        = "mycluster1"
}

module "asg-ebs-test" {
  source                  = "../aws/asg-ebs"
  app_name                = "test_name2"
  app_env                 = "test_env2"
  ami_id                  = "ami-1234567890"
  aws_instance            = { instance_type = "t3.nano", volume_size = "8", instance_count = "1" }
  aws_region              = "us-west-2"
  aws_access_key          = "AKIA1234567890123456"
  aws_secret_key          = "1234567890123456789012345678901234567890"
  private_subnet_ids      = ["1234", "5678"]
  default_sg_id           = "sg-asdf"
  ecs_instance_profile_id = "asdf"
  ecs_cluster_name        = "mycluster1"
  ebs_device              = "/dev/sdh"
  ebs_mount_point         = "/foo/bah"
  ebs_vol_id              = "vol-123456789"
}
