#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

sleep ${startup_delay}

# Install the NFS client utilities
yum install -y nfs-utils

# Mount the EFS file system
mkdir -p ${mount_point}
echo "${efs_dns_name}:/ ${mount_point} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,auto 0 0" >> /etc/fstab
mount -a
