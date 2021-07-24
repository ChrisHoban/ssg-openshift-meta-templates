echo #### Collect Openshift 4 Parameters ####
read -sp 'Openshift 4 Login Token: ' oc4_token
echo
read -p 'Openshift 4 License Plate: ' license
read -p 'Openshift 4 License Env: ' env
read -p 'Docker User: ' dockerUser
read -sp 'Docker Credential: ' dockerCred

# Config Values
appname="csb"
nextcloudImage="nextcloud:22-fpm"
nextcloudImagestreamName="nextcloud"
nginxImage="nginx:alpine"
nginxImagestreamName="nginx"
databaseImage="mariadb:10.2"
databaseImagestreamName="mariadb"
oc4Ns="${license}-${env}"
toolsNs="${license}-tools"
firstTimeDeploy="1"
dockerPullSecret="${nextcloudImagestreamName}-docker-creds"
customNextcloudImagestream="my-nextcloud"
customNginxImagestream="my-nginx"

echo
oc4 login --token=${oc4_token} --server=https://api.silver.devops.gov.bc.ca:6443
oc4 project ${toolsNs}

# One Time Only TOOLS Setup
if [ ${firstTimeDeploy} == "1" ]
then

  oc4 create secret docker-registry ${dockerPullSecret}\
      --docker-server=docker.io \
      --docker-username=${dockerUser} \
      --docker-password=${dockerCred} \
      --docker-email=unused

  echo 'Secret link to Service Accounts'
  oc4 secrets link default ${dockerPullSecret} --for=pull
  oc4 secrets link builder ${dockerPullSecret}

  echo 'Nextcloud ImageStream'
  oc4 process -f docker-image.yaml -p namespace=${toolsNs} -p dockerImage=${nextcloudImage} -p imagestreamName=${nextcloudImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
  echo 'NGINX ImageStream'
  oc4 process -f docker-image.yaml -p namespace=${toolsNs} -p dockerImage=${nginxImage} -p imagestreamName=${nginxImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
  echo 'Database ImageStream'
  oc4 process -f docker-image.yaml -p namespace=${toolsNs} -p dockerImage=${databaseImage} -p imagestreamName=${databaseImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
  echo 'Nextcloud Builder'
  oc4 process -f nextcloud-buildconfig.yaml -p namespace=${toolsNs} -p outputImageName=${customNextcloudImagestream} | oc4 create -f -
  echo 'Custom Nextcloud ImageStream'
  oc4 process -f imagestream.yaml -p namespace=${toolsNs} -p imagestreamName=${customNextcloudImagestream}  | oc4 create -f -
  echo 'Nginx Builder'
  oc4 process -f nginx-buildconfig.yaml -p namespace=${toolsNs} -p outputImageName=${customNginxImagestream} | oc4 create -f -
  echo 'Custom Nginx ImageStream'
  oc4 process -f imagestream.yaml -p namespace=${toolsNs} -p imagestreamName=${customNginxImagestream}  | oc4 create -f -
fi

#Grant access to tools namespace images to the deployment namespace
oc4 process -f cross-namespace-image-puller.yaml -p LICENSE_PLATE=${license} -p ENV=${env} | oc4 create -f -

oc4 project ${oc4Ns}

oc4 process -f nextcloud.yaml -p NEXTCLOUD_HOST=${appname}-${env}.apps.silver.devops.gov.bc.ca -p tools_namespace=${toolsNs} | oc4 create -f -
