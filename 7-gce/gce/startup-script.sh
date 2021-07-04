#! /bin/bash
# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START startup]
set -v

#
# Talk to the metadata server to get the project id

PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
region=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/region" -H "Metadata-Flavor: Google")
zone=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/zone" -H "Metadata-Flavor: Google")
DATA_BACKEND=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DATA_BACKEND" -H "Metadata-Flavor: Google")
CLOUD_STORAGE_BUCKET=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUD_STORAGE_BUCKET" -H "Metadata-Flavor: Google")
CLOUDSQL_USER=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_USER" -H "Metadata-Flavor: Google")
CLOUDSQL_PASSWORD=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_PASSWORD" -H "Metadata-Flavor: Google")
CLOUDSQL_DATABASE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_DATABASE" -H "Metadata-Flavor: Google")
CLOUDSQL_CONNECTION_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/CLOUDSQL_CONNECTION_NAME" -H "Metadata-Flavor: Google")

#echo  PROJECT_ID=$PROJECT_ID >> /etc/profile
#echo  region=$region >> /etc/profile
#echo  zone=$zone >> /etc/profile
#echo  DATA_BACKEND=$DATA_BACKEND >> /etc/profile
#echo  CLOUD_STORAGE_BUCKET=$CLOUD_STORAGE_BUCKET >> /etc/profile
#echo  CLOUDSQL_USER=$CLOUDSQL_USER >> /etc/profile
#echo  CLOUDSQL_PASSWORD=$CLOUDSQL_PASSWORD >> /etc/profile
#echo  CLOUDSQL_DATABASE=$CLOUDSQL_DATABASE >> /etc/profile
#echo  CLOUDSQL_CONNECTION_NAME=$CLOUDSQL_CONNECTION_NAME >> /etc/profile


# Install logging monitor. The monitor will automatically pickup logs sent to
# syslog.
# [START logging]
curl -s "https://storage.googleapis.com/signals-agents/logging/google-fluentd-install.sh" | bash
service google-fluentd restart &
# [END logging]

# Install dependencies from apt
apt-get update
apt-get install -yq \
    git build-essential supervisor python3 python3-dev python3-pip libffi-dev \
    libssl-dev


# Create a pythonapp user. The application will run as this user.
useradd -m -d /home/pythonapp pythonapp

# pip from apt is out of date, so make it update itself and install virtualenv.
pip3 install --upgrade pip virtualenv
echo  PROJECT_ID=$PROJECT_ID >> /home/pythonapp/.bashrc
echo  region=$region >> /home/pythonapp/.bashrc
echo  zone=$zone >> /home/pythonapp/.bashrc
echo  DATA_BACKEND=$DATA_BACKEND >> /home/pythonapp/.bashrc
echo  CLOUD_STORAGE_BUCKET=$CLOUD_STORAGE_BUCKET >> /home/pythonapp/.bashrc
echo  CLOUDSQL_USER=$CLOUDSQL_USER >> /home/pythonapp/.bashrc
echo  CLOUDSQL_PASSWORD=$CLOUDSQL_PASSWORD >> /home/pythonapp/.bashrc
echo  CLOUDSQL_DATABASE=$CLOUDSQL_DATABASE >> /home/pythonapp/.bashrc
echo  CLOUDSQL_CONNECTION_NAME=$CLOUDSQL_CONNECTION_NAME >> /home/pythonapp/.bashrc

# Get the source code from the Google Cloud Repository
# git requires $HOME and it's not set during the startup script.
export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/my-gcp-terraform/r/github_artvalborgcp_getting-started-python /opt/app
cd /opt/app && git checkout mygcpsteps;


# Install app dependencies
virtualenv -p python3 /opt/app/7-gce/env

echo  PROJECT_ID=$PROJECT_ID >> /opt/app/7-gce/env/bin/activate
echo  region=$region >> /opt/app/7-gce/env/bin/activate
echo  zone=$zone >> /opt/app/7-gce/env/bin/activate
echo  DATA_BACKEND=$DATA_BACKEND >> /opt/app/7-gce/env/bin/activate
echo  CLOUD_STORAGE_BUCKET=$CLOUD_STORAGE_BUCKET >> /opt/app/7-gce/env/bin/activate
echo  CLOUDSQL_USER=$CLOUDSQL_USER >> /opt/app/7-gce/env/bin/activate
echo  CLOUDSQL_PASSWORD=$CLOUDSQL_PASSWORD >> /opt/app/7-gce/env/bin/activate
echo  CLOUDSQL_DATABASE=$CLOUDSQL_DATABASE >> /opt/app/7-gce/env/bin/activate
echo  CLOUDSQL_CONNECTION_NAME=$CLOUDSQL_CONNECTION_NAME >> /opt/app/7-gce/env/bin/activate
source /opt/app/7-gce/env/bin/activate
/opt/app/7-gce/env/bin/pip install -r /opt/app/7-gce/requirements.txt

# Make sure the pythonapp user owns the application code
chown -R pythonapp:pythonapp /opt/app

# Configure supervisor to start gunicorn inside of our virtualenv and run the
# application.
cat >/etc/supervisor/conf.d/python-app.conf << EOF
[program:pythonapp]
directory=/opt/app/7-gce
command=/opt/app/7-gce/env/bin/honcho start -f ./procfile worker bookshelf
autostart=true
autorestart=true
user=pythonapp
# Environment variables ensure that the application runs inside of the
# configured virtualenv.
environment=VIRTUAL_ENV="/opt/app/7-gce/env",PATH="/opt/app/7-gce/env/bin",\
    HOME="/home/pythonapp",USER="pythonapp",\
    PROJECT_ID="$PROJECT_ID",region="$region", zone="$zone",DATA_BACKEND="$DATA_BACKEND",CLOUD_STORAGE_BUCKET="$CLOUD_STORAGE_BUCKET",\
    CLOUDSQL_USER="$CLOUDSQL_USER",CLOUDSQL_PASSWORD="$CLOUDSQL_PASSWORD",CLOUDSQL_DATABASE="$CLOUDSQL_DATABASE",\
    CLOUDSQL_CONNECTION_NAME="$CLOUDSQL_CONNECTION_NAME"


stdout_logfile=syslog
stderr_logfile=syslog
EOF

supervisorctl reread
supervisorctl update

# Application should now be running under supervisor

cd /usr/local/bin
curl  https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -o cloud_sql_proxy
chmod +x cloud_sql_proxy

cat >/etc/systemd/system/cloud-sql-proxy.service << EOF
[Unit]
Description=Connecting MySQL Client from Compute Engine using the Cloud SQL Proxy
Documentation=https://cloud.google.com/sql/docs/mysql/connect-compute-engine
Requires=networking.service
After=networking.service

[Service]
WorkingDirectory=/usr/local/bin
ExecStart=/usr/local/bin/cloud_sql_proxy -dir=/var/run/cloud-sql-proxy -instances=$CLOUDSQL_CONNECTION_NAME=tcp:3306
Restart=always
StandardOutput=journal
User=pythonapp

[Install]
WantedBy=multi-user.target

EOF
systemctl daemon-reload
systemctl enable cloud-sql-proxy
systemctl start cloud-sql-proxy

# [END startup]
