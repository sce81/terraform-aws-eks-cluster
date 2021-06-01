#!/bin/bash
set -o xtrace
#Set the proxy variables before running the bootstrap.sh script
set -a
source /etc/environment
/etc/eks/bootstrap.sh ${CLUSTERNAME} --apiserver-endpoint ${ENDPOINT} --b64-cluster-ca ${CERTIFICATE}

sudo yum update -y
sudo yum install -y https://s3.${REGION}.amazonaws.com/amazon-ssm-${REGION}/latest/linux_amd64/amazon-ssm-agent.rpm

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
