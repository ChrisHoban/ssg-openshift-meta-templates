#!/bin/bash
echo #### collect the params ####

read -sp 'Openshift 3 Login Token: ' oc3_token
echo "\n"
read -p 'Openshift 3 License Plate: ' oc3_ns
echo "\n"
read -p 'Project Name: ' oc3_projectname

echo ### Edit the below to point to your renamed oc3 and oc4 binary locations
export PATH=$PATH:~c:/oc/
export PATH=$PATH:~c:/oc4/

#### Comment out the objects you don't want to migrate ####
kubernetes_obj=()
kubernetes_obj+=('buildconfigs')
kubernetes_obj+=('imagestreams')
kubernetes_obj+=('services')
kubernetes_obj+=('cm')
kubernetes_obj+=('secrets')
kubernetes_obj+=('egressnetworkpolicies')
kubernetes_obj+=('statefulsets')
kubernetes_obj+=('cronjobs')
kubernetes_obj+=('serviceaccounts')
kubernetes_obj+=('rolebindings')
kubernetes_obj+=('endpoints')
kubernetes_obj+=('deploymentconfigs')
kubernetes_obj+=('replicationcontrollers')
kubernetes_obj+=('builds')
kubernetes_obj+=('imagestreamtags')
kubernetes_obj+=('rolebindingrestrictions')
kubernetes_obj+=('limitranges')
kubernetes_obj+=('resourcequotas')
kubernetes_obj+=('pvc')
kubernetes_obj+=('templates')
kubernetes_obj+=('hpa')
kubernetes_obj+=('deployments')
kubernetes_obj+=('replicasets')
kubernetes_obj+=('poddisruptionbudget')
kubernetes_obj+=('pods')


echo #### Just in case you have an oc4 session ####
oc4 logout
echo ###### LOGIN TO OC3 ########
oc3 login https://console.pathfinder.gov.bc.ca:8443 --token=${oc3_token}

echo #### create all the dirs branching off from where you placed/ran this script #####

mkdir ${oc3_projectname}-export
cd ${oc3_projectname}-export
mkdir ${oc3_projectname}-tools
mkdir ${oc3_projectname}-dev
mkdir ${oc3_projectname}-test
mkdir ${oc3_projectname}-prod

echo ##### Openshift 3 Tools ######
cd ${oc3_projectname}-tools
oc3 project ${oc3_ns}-tools

echo #### Get the legacy main object backup (RAW) ####
oc3 get -o yaml --export all > ${oc3_projectname}-rawbackup.yaml

echo #### Backup discrete kubernetes templates by object type ####
for t in ${kubernetes_obj[@]}; do
  oc3 export ${t} --as-template=${oc3_projectname}-${t} > ${oc3_projectname}-${t}.yaml
done

echo##  Get back to parent directory for next stage
cd ..

echo ##### Openshift 3 Dev ######
cd ${oc3_projectname}-dev
oc3 project ${oc3_ns}-dev

echo #### Get the legacy main object backup (RAW) ####
oc3 get -o yaml --export all > ${oc3_projectname}-rawbackup.yaml

echo #### Backup discrete kubernetes templates by object type ####
for t in ${kubernetes_obj[@]}; do
  oc3 export ${t} --as-template=${oc3_projectname}-${t} > ${oc3_projectname}-${t}.yaml
done
echo ### Get back to parent directory for next stage ###
cd ..

echo ##### Openshift 3 Test ######
cd ${oc3_projectname}-test
oc3 project ${oc3_ns}-test

echo ### Get the legacy main object backup (RAW) ###
oc3 get -o yaml --export all > ${oc3_projectname}-rawbackup.yaml

echo #### Backup discrete kubernetes templates by object type ####
for t in ${kubernetes_obj[@]}; do
  oc3 export ${t} --as-template=${oc3_projectname}-${t} > ${oc3_projectname}-${t}.yaml
done

echo ### Get back to parent directory for next stage ###
cd ..

echo ##### Openshift 3 Prod ######
cd ${oc3_projectname}-prod
oc3 project ${oc3_ns}-prod

echo ### Get the legacy main object backup (RAW) ###
oc3 get -o yaml --export all > ${oc3_projectname}-rawbackup.yaml

echo #### Backup discrete kubernetes templates by object type ####
for t in ${kubernetes_obj[@]}; do
  oc3 export ${t} --as-template=${oc3_projectname}-${t} > ${oc3_projectname}-${t}.yaml
done
cd ..

echo #### Logging out of Openshift 3 ####
oc3 logout

echo #### Collect Openshift 4 Parameters ####
read -sp 'Openshift 4 Login Token: ' oc4_token
read -p 'Openshift 4 License Plate: ' oc4_ns

oc4 login --token=${oc4_token} --server=https://api.silver.devops.gov.bc.ca:6443


echo ##### Move to Openshift 3 Tools Export Directory #####

oc4 project ${oc4_ns}-tools


echo ### Import Tools First ###
cd ${oc3_projectname}-tools

echo #### Backup discrete kubernetes templates by object type ####
for t in ${kubernetes_obj[@]}; do
  echo ##### Process and Create ${t} #####
  oc4 process -f ${oc3_projectname}-${t}.yaml -l migration=${oc3_projectname}-migration-template | oc4 create -f -
done

pause ' Press Enter to Rollback, or CTRL-C and Y to quit, (Rollback is not for all objects yet)'

oc4 delete all --selector migration=${oc3_projectname}-migration-template

echo #### Logout of Openshift 4 ####
oc4 logout
