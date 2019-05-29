#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

# Execute optional command supplied by user.
${additional_user_data}
