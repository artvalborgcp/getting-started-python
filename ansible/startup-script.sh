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

echo  PROJECT_ID=$PROJECT_ID >> /etc/environment
echo  region=$region >> /etc/environment
echo  zone=$zone >> /etc/environment
echo  DATA_BACKEND=$DATA_BACKEND >> /etc/environment
echo  CLOUD_STORAGE_BUCKET=$CLOUD_STORAGE_BUCKET >> /etc/environment
echo  CLOUDSQL_USER=$CLOUDSQL_USER >> /etc/environment
echo  CLOUDSQL_PASSWORD=$CLOUDSQL_PASSWORD >> /etc/environment
echo  CLOUDSQL_DATABASE=$CLOUDSQL_DATABASE >> /etc/environment
echo  CLOUDSQL_CONNECTION_NAME=$CLOUDSQL_CONNECTION_NAME >> /etc/environment
echo  "export PROJECT_ID" >> /etc/environment
echo  "export region" >> /etc/environment
echo  "export zone" >> /etc/environment
echo  "export DATA_BACKEND" >> /etc/environment
echo  "export CLOUD_STORAGE_BUCKET" >> /etc/environment
echo  "export CLOUDSQL_USER" >> /etc/environment
echo  "export CLOUDSQL_PASSWORD" >> /etc/environment
echo  "export CLOUDSQL_DATABASE" >> /etc/environment
echo  "export CLOUDSQL_CONNECTION_NAME" >> /etc/environment

source /etc/environment

apt-get update
apt-get install -yq \
    git build-essential supervisor python3 python3-dev python3-pip libffi-dev \
    libssl-dev ansible

export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/${PROJECT_ID}/r/github_artvalborgcp_getting-started-python /opt/app
cd /opt/app && git checkout mygcpsteps;

cd ansible/
ansible-playbook tasks/playbook.yml -v