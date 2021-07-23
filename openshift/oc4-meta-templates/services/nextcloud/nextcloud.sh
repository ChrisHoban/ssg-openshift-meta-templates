echo #### Collect Openshift 4 Parameters ####
read -sp 'Openshift 4 Login Token: ' oc4_token
echo
read -p 'Openshift 4 License Plate: ' license
read -p 'Openshift 4 License Env: ' env
read -p 'Docker User: ' dockerUser
read -sp 'Docker Credential: ' dockerCred

# Nextcloud component docker images
nextcloudImage=nextcloud:22-fpm
nextcloudImagestreamName=nextcloud
nginxImage=nginx:alpine
nginxImagestreamName=nginx
databaseImage=mariadb:latest
databaseImagestreamName=mariadb
oc4_ns = ${license}-${env}

dockerPullSecret = ${nextcloudImagestreamName}-docker-creds
echo
oc4 login --token=${oc4_token} --server=https://api.silver.devops.gov.bc.ca:6443
oc4 project ${oc4_ns}

oc4 create secret docker-registry ${dockerPullSecret} \
    --docker-server=docker.io \
    --docker-username=${dockerUser} \
    --docker-password=${dockerCred} \
    --docker-email=unused

echo 'Secret link to Service Accounts'
oc4 secrets link default ${dockerPullSecret} --for=pull
oc4 secrets link builder ${dockerPullSecret}

echo 'Nextcloud ImageStream'
oc4 process -f docker-image.yaml -p namespace=${oc4_ns} -p dockerImage=${nextcloudImage} -p imagestreamName=${nextcloudImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
echo 'NGINX ImageStream'
oc4 process -f docker-image.yaml -p namespace=${oc4_ns} -p dockerImage=${nginxImage} -p imagestreamName=${nginxImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
echo 'Database ImageStream'
oc4 process -f docker-image.yaml -p namespace=${oc4_ns} -p dockerImage=${databaseImage} -p imagestreamName=${databaseImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -

oc4 process -f nextcloud.yaml -p NEXTCLOUD_HOST=csb-${env}.apps.silver.devops.gov.bc.ca | oc4 create -f -
