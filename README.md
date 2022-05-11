# docker-openstack-gpg-backup
Simple docker container for encrypting and backing up data to S3 service using OpenStack API
# Quick Start
1. Build image
2. Create S3 bucket and generate openrc.sh file like this
```
#!/bin/bash
export OS_AUTH_URL=https://auth.cloud.ovh.net/v3
export OS_USER_DOMAIN_NAME=${OS_USER_DOMAIN_NAME:-"Default"}
export OS_PROJECT_DOMAIN_NAME=${OS_PROJECT_DOMAIN_NAME:-"Default"}
export OS_TENANT_ID=TENANT_ID
export OS_TENANT_NAME="TENANT_NAME"
export OS_USERNAME="USERNAME"
export OS_PASSWORD="PASSWORD"
export OS_REGION_NAME="REGION"
```
3. Copy openrc.sh and public gpg keys into directory that can be mounted by the docker container
4. Run container using
```
docker run \
--volume path/to/config:/config \ 
--volume path/to/data:/data \
--env "CRON=0 1 * * *" \
--env "DELETE_AFTER=120"  \
--env "BUCKET=bucket" \ 
--env "AUTO_REMOVE=true" \ 
image-name
```
every **file** in /data folder will be encrypted and uploaded to S3 bucket and if option 
`AUTO_REMOVE` if set to true files will be removed after upload 
`DELETE_AFTER` option will set `X-Delete-After` header which allows to automatically remove old backups from bucket.
