echo #### Collect Openshift 4 Parameters ####
read -sp 'Openshift 4 Login Token: ' oc4_token
echo
read -p 'Openshift 4 License Plate: ' license
read -p 'Openshift 4 License Env: ' env
echo
oc4Ns="${license}-${env}"
toolsNs="${license}-tools"
oc login --token=${oc4_token} --server=https://api.silver.devops.gov.bc.ca:6443
echo
oc project ${toolsNs}
oc get all,configmap,pvc,cronjobs,rolebinding,secret --selector appcluster=nextcloud -o name
read -p 'Delete All from tools? (y): ' deleteall
if [ ${deleteall} == "y" ]
then
  oc delete all,configmap,pvc,cronjobs,rolebinding,secret --selector appcluster=nextcloud
fi
oc project ${oc4Ns}
oc get all,configmap,pvc,cronjobs,rolebinding,secret --selector appcluster=nextcloud -o name
read -p 'Delete All from env? (Y): ' deleteall
if [ ${deleteall} == "y" ]
then
  oc delete all,configmap,pvc,cronjobs,rolebinding,secret --selector appcluster=nextcloud
fi
