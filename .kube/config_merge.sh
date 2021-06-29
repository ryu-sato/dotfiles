#!/bin/bash -eux
# https://medium.com/@jacobtomlinson/how-to-merge-kubernetes-kubectl-config-files-737b61bd517d

confi_dir="~/.kube/sub-config/"
file=$(tempfile)
echo $file
KUBECONFIG=$(find $config_dir -name 'config*' | xargs | tr ' ' ':') kubectl config view --flatten | tee $file

