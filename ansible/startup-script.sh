#! /bin/bash
set -v



apt-get update
apt-get install -yq \
    git build-essential supervisor python3 python3-dev python3-pip libffi-dev \
    libssl-dev ansible

export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/my-gcp-terraform/r/github_artvalborgcp_getting-started-python /opt/app
cd /opt/app && git checkout mygcpsteps;
