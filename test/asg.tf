# Using required inputs
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

# Using required and optional inputs
module "asg-test2" {
  source                      = "../aws/asg"
  app_name                    = "test_name1"
  app_env                     = "test_env1"
  ami_id                      = "ami-1234567890"
  aws_instance                = { instance_type = "t3.nano", volume_size = "8", instance_count = "1" }
  private_subnet_ids          = ["1234", "5678"]
  default_sg_id               = "sg-asdf"
  ecs_instance_profile_id     = "asdf"
  ecs_cluster_name            = "mycluster1"
  key_name                    = "fred"
  root_device_name            = "/dev/sda"
  additional_security_groups  = ["sg-qwerty"]
  associate_public_ip_address = true
  additional_user_data        = "chown 1000:1000 /mydata"
  tags                        = { managed_by = "terraform", workspace = terraform.workspace }
  cpu_credits                 = "standard"
}

module "asg-ebs-test2" {
  source                      = "../aws/asg-ebs"
  app_name                    = "test_name2"
  app_env                     = "test_env2"
  ami_id                      = "ami-1234567890"
  aws_instance                = { instance_type = "t3.nano", volume_size = "8", instance_count = "1" }
  aws_region                  = "us-west-2"
  aws_access_key              = "AKIA1234567890123456"
  aws_secret_key              = "1234567890123456789012345678901234567890"
  private_subnet_ids          = ["1234", "5678"]
  default_sg_id               = "sg-asdf"
  ecs_instance_profile_id     = "asdf"
  ecs_cluster_name            = "mycluster1"
  ebs_device                  = "/dev/sdh"
  ebs_mount_point             = "/foo/bah"
  ebs_vol_id                  = "vol-123456789"
  key_name                    = "fred"
  root_device_name            = "/dev/sda"
  additional_security_groups  = ["sg-qwerty"]
  associate_public_ip_address = true
  additional_user_data        = "chown 1000:1000 /mydata"
  ebs_mkfs_label              = "MyData"
  ebs_mkfs_labelflag          = "-L"
  ebs_mkfs_extraopts          = "-m 2 -i 32768"
  ebs_fs_type                 = "ext3"
  ebs_mountopts               = "noatime"
  tags                        = { managed_by = "terraform", workspace = terraform.workspace }
  cpu_credits                 = "standard"
}
