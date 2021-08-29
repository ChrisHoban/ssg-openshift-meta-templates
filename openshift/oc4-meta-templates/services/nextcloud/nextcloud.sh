echo #### Collect Openshift 4 Parameters ####
read -sp 'Openshift 4 Login Token: ' oc4_token
echo
read -p 'Openshift 4 License Plate: ' license
read -p 'Openshift 4 License Env: ' env
read -p 'Docker User: ' dockerUser
read -sp 'Docker Credential: ' dockerCred

# Config Values
appname="csb-sft"
nextcloudName="${appname}-nextcloud"
nextcloudImage="nextcloud:22-fpm"
nextcloudImagestreamName="nextcloud"
nginxImage="nginx:alpine"
nginxImagestreamName="nginx"
databaseImage="mysql:latest"
databaseImagestreamName="mysql"
oc4Ns="${license}-${env}"
toolsNs="${license}-tools"
firstTimeDeploy="0"
firstTimeNamespace="0"
dockerPullSecret="${nextcloudImagestreamName}-docker-creds"
customNextcloudImagestream="my-nextcloud"
customNginxImagestream="my-nginx"
ipWhitelist="*"
cronUrl="http://${nextcloudName}:8080/cron.php"




echo
oc login --token=${oc4_token} --server=https://api.silver.devops.gov.bc.ca:6443
oc project ${toolsNs}


# One Time Only TOOLS Setup
if [ ${firstTimeDeploy} == "1" ]
then

  oc create secret docker-registry ${dockerPullSecret}\
      --docker-server=docker.io \
      --docker-username=${dockerUser} \
      --docker-password=${dockerCred} \
      --docker-email=unused

  echo 'Secret link to Service Accounts'
  oc secrets link default ${dockerPullSecret} --for=pull
  oc secrets link builder ${dockerPullSecret}

  echo 'Nextcloud ImageStream'
  oc process -f docker-image.yaml -p namespace=${toolsNs} -p dockerImage=${nextcloudImage} -p imagestreamName=${nextcloudImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
  echo 'NGINX ImageStream'
  oc process -f docker-image.yaml -p namespace=${toolsNs} -p dockerImage=${nginxImage} -p imagestreamName=${nginxImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
  echo 'Database ImageStream'
  oc process -f docker-image.yaml -p namespace=${toolsNs} -p dockerImage=${databaseImage} -p imagestreamName=${databaseImagestreamName} -p dockerPullSecret=${dockerPullSecret} | oc4 create -f -
  echo 'Nextcloud Builder'
  oc process -f nextcloud-buildconfig.yaml -p namespace=${toolsNs} -p outputImageName=${customNextcloudImagestream} | oc4 create -f -
  echo 'Custom Nextcloud ImageStream'
  oc process -f imagestream.yaml -p namespace=${toolsNs} -p imagestreamName=${customNextcloudImagestream}  | oc4 create -f -
  echo 'Nginx Builder'
  oc process -f nginx-buildconfig.yaml -p namespace=${toolsNs} -p outputImageName=${customNginxImagestream} | oc4 create -f -
  echo 'Custom Nginx ImageStream'
  oc process -f imagestream.yaml -p namespace=${toolsNs} -p imagestreamName=${customNginxImagestream}  | oc4 create -f -
fi

# One Time Only Namespace Permissions
if [ ${firstTimeNamespace} == "1" ]
then
  #Grant access to tools namespace images to the deployment namespace
  oc4 process -f cross-namespace-image-puller.yaml -p LICENSE_PLATE=${license} -p ENV=${env} | oc4 create -f -
fi

oc4 project ${oc4Ns}

# One Time Only Namespace DB Deploy
if [ ${firstTimeNamespace} == "1" ]
then
  oc4 process -f mysql.yaml -p tools_namespace=${toolsNs} -p MYSQL_DATABASE=${nextcloudName} | oc4 create -f -
fi

oc4 process -f nextcloud.yaml -p NEXTCLOUD_HOST=${appname}-${env}.apps.silver.devops.gov.bc.ca -p tools_namespace=${toolsNs} -p MYSQL_DATABASE=${nextcloudName} -p nextcloud_name=${nextcloudName} -p ip_whitelist=${ipWhitelist} -p CURL_URL=${cronUrl} | oc4 create -f -
