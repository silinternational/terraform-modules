#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

# Install the NFS client utilities
echo "user_data.sh: Installing nfs-utils"
yum install -y nfs-utils

# Mount the EFS file system
echo "user_data.sh: Mounting EFS file system at ${mount_point}"
mkdir -p ${mount_point}
echo "${efs_dns_name}:/ ${mount_point} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,auto 0 0" >> /etc/fstab
mount -a


# Install the AWS CLI
echo "user_data.sh: Installing the AWS CLI"
yum install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Configure the AWS CLI
echo "user_data.sh: Configuring the AWS CLI"
mkdir ~/.aws
echo "[default]"               > ~/.aws/config
echo "region = ${aws_region}" >> ~/.aws/config

echo "[default]"                                  > ~/.aws/credentials
echo "aws_access_key_id = ${aws_access_key}"     >> ~/.aws/credentials
echo "aws_secret_access_key = ${aws_secret_key}" >> ~/.aws/credentials

# Get my EC2 instance ID
# From https://stackoverflow.com/questions/625644/how-to-get-the-instance-id-from-within-an-ec2-instance
# INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
echo "user_data.sh: Getting EC2 instance ID"
INSTANCE_ID=`ec2-metadata --instance-id | sed -e 's/.* //' | tr -d \\n`
echo "user_data.sh: EC2 instance ID is $INSTANCE_ID"

# Attach EBS volume
echo "user_data.sh: Attaching EBS volume"
aws ec2 attach-volume --device ${ebs_device} --instance-id $INSTANCE_ID --volume-id ${ebs_vol_id}

# Check for existence of data partition
echo "user_data.sh: Looking for partition on EBS volume"

# Check for existence of file system on EBS volume data partition
echo "user_data.sh: Looking for file system on EBS volume"

# Create file system mount point
#if ! -e dollar{mount_point}; then
#	mkdir -p dollar{mount_point}
#fi

# Mount the EBS volume's file system
echo "user_data.sh: Mounting file system on EBS volume at ${ebs_mount_point}"
#FIXME echo "${ebs_device} ${ebs_mount_point} ext4 defaults 0 0" >> /etc/fstab
#mount -a

# Execute optional command supplied by user.
echo "user_data.sh: Executing user-supplied additional user data: ${additional_user_data}"
${additional_user_data}
