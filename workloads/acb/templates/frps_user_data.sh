#!/bin/bash

set -e

dnf update -y

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/instance-id")

aws ssm send-command \
    --targets "Key=instanceIds,Values=$INSTANCE_ID" \
    --document-name "AWS-ApplyAnsiblePlaybooks" \
    --comment "Run Ansible Playbook for FRPS" \
    --parameters '{"SourceType":["S3"],"SourceInfo":["{\"path\":\"${FRPS_PLAYBOOK_S3_ENDPOINT}\"}"],"InstallDependencies":["True"],"PlaybookFile":["frps.yaml"],"ExtraVariables":[${FRPS_PLAYBOOK_VARS}],"Check":["False"],"Verbose":["-v"]}' \
    --region ${AWS_REGION}