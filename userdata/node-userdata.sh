#!/bin/bash
source /etc/environment
#/etc/eks/bootstrap.sh nonprod-eks
/etc/eks/bootstrap.sh ${ClusterName} --b64-cluster-ca ${ClusterCA} --apiserver-endpoint ${ClusterAPIEndpoint} 
