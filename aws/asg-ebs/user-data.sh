#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

# Install the AWS CLI (needed to enable attaching the EBS volume)
echo "user_data.sh: Installing the AWS CLI"
yum install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
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
echo "user_data.sh: Getting EC2 instance ID"
INSTANCE_ID=`ec2-metadata --instance-id | sed -e 's/.* //' | tr -d \\n`
echo "user_data.sh: EC2 instance ID is $INSTANCE_ID"

# Attach the EBS volume
echo "user_data.sh: Attaching EBS volume ${ebs_vol_id} as device ${ebs_device}"
aws ec2 attach-volume --device ${ebs_device} --instance-id $INSTANCE_ID --volume-id ${ebs_vol_id}

# Wait until volume is "attached" and "in-use"
# Two "State" entries are returned. One refers to the state of the
# attachment (we want "attached"). The other refers to the state of
# the attached volume (we want "in-use"). We'll sit in a loop until
# we get both states returned.
while (true) do
        STATE=`aws ec2 describe-volumes --volume-ids ${ebs_vol_id} | grep State | sed -e 's/.* "//' -e 's/",//'`
        if [[ "$STATE" =~ attached.*in-use ]]; then
                break;
        else
                echo "user_data.sh: Waiting for volume to become ready"
                sleep 2
        fi
done

# Create the filesystem on the unpartitioned volume.  If the volume
# doesn't have a filesystem, create one with the filesystem label
# ${ebs_mkfs_label}.

# Create file system on EBS volume if one doesn't exist
echo "user_data.sh: Looking for existing file system on EBS volume"
udevadm settle
FSEXISTS=`file --special-files --dereference ${ebs_device} | grep "filesystem data"`
if [ "$FSEXISTS" == "" ]; then
	echo "user_data.sh: Creating file system on EBS volume"
	mkfs --type ${ebs_fs_type} ${ebs_mkfs_labelflag} ${ebs_mkfs_label} ${ebs_mkfs_extraopts} ${ebs_device}
fi

# Create file system mount point
if [ ! -e ${ebs_mount_point} ]; then
	echo "user_data.sh: Creating file system mount point (${ebs_mount_point})"
	mkdir -p ${ebs_mount_point}
fi

# Mount the EBS volume's file system
echo "user_data.sh: Mounting file system on EBS volume at ${ebs_mount_point}"
echo "LABEL=${ebs_mkfs_label} ${ebs_mount_point} ${ebs_fs_type} ${ebs_mountopts} 0 0" >> /etc/fstab
mount -a

# Execute optional command supplied by user.
echo "user_data.sh: Executing user-supplied additional user data: ${additional_user_data}"
${additional_user_data}
