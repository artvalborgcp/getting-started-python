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

# VariablesList of metadata_startup_script
variablesList=region,zone,DATA_BACKEND,CLOUD_STORAGE_BUCKET,CLOUDSQL_USER,CLOUDSQL_PASSWORD,CLOUDSQL_DATABASE,CLOUDSQL_CONNECTION_NAME;
for val in ${variablesList//,/ }
do
   response_code=$(curl --write-out '%{http_code}' --silent --output /dev/null "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$val" -H "Metadata-Flavor: Google")
   if [[ "$response_code" -ne 200 ]] ; then
     continue
   else
     echo $val=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$val" -H "Metadata-Flavor: Google") >> /etc/profile
   fi;
done
# Talk to the metadata server to get the project id
PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
echo  PROJECT_ID=$PROJECT_ID >> /etc/profile


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
User=root

[Install]
WantedBy=multi-user.target

EOF
systemctl daemon-reload
systemctl enable cloud-sql-proxy
systemctl start cloud-sql-proxy
# Create a pythonapp user. The application will run as this user.
useradd -m -d /home/pythonapp pythonapp

# pip from apt is out of date, so make it update itself and install virtualenv.
pip3 install --upgrade pip virtualenv

# Get the source code from the Google Cloud Repository
# git requires $HOME and it's not set during the startup script.
export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/my-gcp-terraform/r/github_artvalborgcp_getting-started-python /opt/app
cd /opt/app && git checkout mygcpsteps;
# Install app dependencies
virtualenv -p python3 /opt/app/7-gce/env
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
# [END startup]
