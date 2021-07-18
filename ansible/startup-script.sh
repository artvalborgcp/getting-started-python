#! /bin/bash
set -v

PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
region=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/region" -H "Metadata-Flavor: Google")
zone=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/zone" -H "Metadata-Flavor: Google")
DATA_BACKEND=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DATA_BACKEND" -H "Metadata-Flavor: Google")
CLOUD_STORAGE_BUCKET=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUD_STORAGE_BUCKET" -H "Metadata-Flavor: Google")
CLOUDSQL_USER=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_USER" -H "Metadata-Flavor: Google")
CLOUDSQL_PASSWORD=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_PASSWORD" -H "Metadata-Flavor: Google")
CLOUDSQL_DATABASE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_DATABASE" -H "Metadata-Flavor: Google")
CLOUDSQL_CONNECTION_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_CONNECTION_NAME" -H "Metadata-Flavor: Google")


apt-get update
apt-get install -yq \
    git build-essential supervisor python3 python3-dev python3-pip libffi-dev \
    libssl-dev ansible

export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/my-gcp-terraform/r/github_artvalborgcp_getting-started-python /opt/app
cd /opt/app && git checkout mygcpsteps;
cd ansible/
ansible-playbook playbook.yml -v