#!/bin/bash -eux
# https://medium.com/@jacobtomlinson/how-to-merge-kubernetes-kubectl-config-files-737b61bd517d
# kubie により ~/.kube/sub-config/ 配下の設定ファイルが読み込める場合は使わない方が良い

config_dir=~/.kube/sub-config/
file=$(tempfile)
KUBECONFIG=$(find $config_dir -name 'config*' | xargs | tr ' ' ':') kubectl config view --flatten | tee $file

