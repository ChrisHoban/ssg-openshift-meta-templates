echo #### Collect Openshift 4 Parameters ####
read -sp 'Openshift 4 Login Token: ' oc4_token
echo
read -p 'Openshift 4 Namespace: ' oc4_ns
read -p 'Docker Image (ie rabbitmq:3.8): ' dockerImage
read -p 'Imagestream Name (ie rabbitmq): ' imagestreamName
read -p 'Docker User: ' dockerUser
read -sp 'Docker Credential: ' dockerCred
echo
dockerPullSecret = ${imagestreamName}-docker-creds

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

echo 'Secret Image Template Process'
oc4 process -f docker-image.yaml -p namespace=${oc4_ns} -p dockerImage=${dockerImage} -p imagestreamName=${imagestreamName} -p dockerPullSecret=${dockerPullSecret}| oc4 create -f -

oc4 logout
