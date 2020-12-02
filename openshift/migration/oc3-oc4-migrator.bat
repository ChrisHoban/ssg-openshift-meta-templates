@echo on
setlocal EnableDelayedExpansion
REM #### collect the params ####

set /p oc3_token=Openshift 3 Login Token:
set /p oc3_ns=Openshift 3 License Plate:
set /p oc3_projectname=Project Name:


REM ###### LOGIN TO OC3 ########
oc3 login https://console.pathfinder.gov.bc.ca:8443 --token=%oc3_token%

REM #### create all the dirs branching off from where you placed/ran this script #####

mkdir %oc3_projectname%-export
cd %oc3_projectname%-export
mkdir %oc3_projectname%-tools
mkdir %oc3_projectname%-dev
mkdir %oc3_projectname%-test
mkdir %oc3_projectname%-prod

REM ##### Openshift 3 Tools ######
cd %oc3_projectname%-tools
oc3 project %oc3_ns%-tools

REM #### Get the legacy main object backup (RAW) ####
oc3 get -o yaml --export all > %oc3_projectname%-rawbackup.yaml

oc3 get services --export > services

REM #### Backup discrete kubernetes templates by object type ####
clear pods --as-template=%oc3_projectname%-pods > %oc3_projectname%-pods.yaml
oc3 export replicationcontrollers --as-template=%oc3_projectname%-replicationcontrollers > %oc3_projectname%-replicationcontrollers.yaml
oc3 export services --as-template=%oc3_projectname%-services > %oc3_projectname%-services.yaml
oc3 export deploymentconfigs --as-template=%oc3_projectname%-deploymentconfigs > %oc3_projectname%-deploymentconfigs.yaml
oc3 export buildconfigs --as-template=%oc3_projectname%-buildconfigs > %oc3_projectname%-buildconfigs.yaml
oc3 export builds --as-template=%oc3_projectname%-builds > %oc3_projectname%-builds.yaml
oc3 export imagestreams --as-template=%oc3_projectname%-imagestreams > %oc3_projectname%-imagestreams.yaml
oc3 export routes --as-template=%oc3_projectname%-routes > %oc3_projectname%-routes.yaml
oc3 export rolebindings --as-template=%oc3_projectname%-rolebindings > %oc3_projectname%-rolebindings.yaml
oc3 export serviceaccounts --as-template=%oc3_projectname%-serviceaccounts > %oc3_projectname%-serviceaccounts.yaml
oc3 export secrets --as-template=%oc3_projectname%-secrets > %oc3_projectname%-secrets.yaml
oc3 export imagestreamtags --as-template=%oc3_projectname%-imagestreamtags > %oc3_projectname%-imagestreamtags.yaml
oc3 export cm --as-template=%oc3_projectname%-cm > %oc3_projectname%-cm.yaml
oc3 export egressnetworkpolicies --as-template=%oc3_projectname%-egressnetworkpolicies > %oc3_projectname%-egressnetworkpolicies.yaml
oc3 export rolebindingrestrictions --as-template=%oc3_projectname%-rolebindingrestrictions > %oc3_projectname%-rolebindingrestrictions.yaml
oc3 export limitranges --as-template=%oc3_projectname%-limitranges > %oc3_projectname%-limitranges.yaml
oc3 export resourcequotas --as-template=%oc3_projectname%-resourcequotas > %oc3_projectname%-resourcequotas.yaml
oc3 export pvc --as-template=%oc3_projectname%-pvc > %oc3_projectname%-pvc.yaml
oc3 export templates --as-template=%oc3_projectname%-templates > %oc3_projectname%-templates.yaml
oc3 export cronjobs --as-template=%oc3_projectname%-cronjobs > %oc3_projectname%-cronjobs.yaml
oc3 export statefulsets --as-template=%oc3_projectname%-statefulsets > %oc3_projectname%-statefulsets.yaml
oc3 export hpa --as-template=%oc3_projectname%-hpa > %oc3_projectname%-hpa.yaml
oc3 export deployments --as-template=%oc3_projectname%-deployments > %oc3_projectname%-deployments.yaml
oc3 export replicasets --as-template=%oc3_projectname%-replicasets > %oc3_projectname%-replicasets.yaml
oc3 export poddisruptionbudget --as-template=%oc3_projectname%-poddisruptionbudget > %oc3_projectname%-poddisruptionbudget.yaml
oc3 export endpoints --as-template=%oc3_projectname%-endpoints > %oc3_projectname%-endpoints.yaml

REM##  Get back to parent directory for next stage
cd ..

REM ##### Openshift 3 Dev ######
cd %oc3_projectname%-dev
oc3 project %oc3_ns%-dev

REM #### Get the legacy main object backup (RAW) ####
oc3 get -o yaml --export all > %oc3_projectname%-rawbackup.yaml

REM Backup discrete kubernetes templates by object type
oc3 export pods --as-template=%oc3_projectname%-pods > %oc3_projectname%-pods.yaml
oc3 export replicationcontrollers --as-template=%oc3_projectname%-replicationcontrollers > %oc3_projectname%-replicationcontrollers.yaml
oc3 export services --as-template=%oc3_projectname%-services > %oc3_projectname%-services.yaml
oc3 export deploymentconfigs --as-template=%oc3_projectname%-deploymentconfigs > %oc3_projectname%-deploymentconfigs.yaml
oc3 export buildconfigs --as-template=%oc3_projectname%-buildconfigs > %oc3_projectname%-buildconfigs.yaml
oc3 export builds --as-template=%oc3_projectname%-builds > %oc3_projectname%-builds.yaml
oc3 export imagestreams --as-template=%oc3_projectname%-imagestreams > %oc3_projectname%-imagestreams.yaml
oc3 export routes --as-template=%oc3_projectname%-routes > %oc3_projectname%-routes.yaml
oc3 export rolebindings --as-template=%oc3_projectname%-rolebindings > %oc3_projectname%-rolebindings.yaml
oc3 export serviceaccounts --as-template=%oc3_projectname%-serviceaccounts > %oc3_projectname%-serviceaccounts.yaml
oc3 export secrets --as-template=%oc3_projectname%-secrets > %oc3_projectname%-secrets.yaml
oc3 export imagestreamtags --as-template=%oc3_projectname%-imagestreamtags > %oc3_projectname%-imagestreamtags.yaml
oc3 export cm --as-template=%oc3_projectname%-cm > %oc3_projectname%-cm.yaml
oc3 export egressnetworkpolicies --as-template=%oc3_projectname%-egressnetworkpolicies > %oc3_projectname%-egressnetworkpolicies.yaml
oc3 export rolebindingrestrictions --as-template=%oc3_projectname%-rolebindingrestrictions > %oc3_projectname%-rolebindingrestrictions.yaml
oc3 export limitranges --as-template=%oc3_projectname%-limitranges > %oc3_projectname%-limitranges.yaml
oc3 export resourcequotas --as-template=%oc3_projectname%-resourcequotas > %oc3_projectname%-resourcequotas.yaml
oc3 export pvc --as-template=%oc3_projectname%-pvc > %oc3_projectname%-pvc.yaml
oc3 export templates --as-template=%oc3_projectname%-templates > %oc3_projectname%-templates.yaml
oc3 export cronjobs --as-template=%oc3_projectname%-cronjobs > %oc3_projectname%-cronjobs.yaml
oc3 export statefulsets --as-template=%oc3_projectname%-statefulsets > %oc3_projectname%-statefulsets.yaml
oc3 export hpa --as-template=%oc3_projectname%-hpa > %oc3_projectname%-hpa.yaml
oc3 export deployments --as-template=%oc3_projectname%-deployments > %oc3_projectname%-deployments.yaml
oc3 export replicasets --as-template=%oc3_projectname%-replicasets > %oc3_projectname%-replicasets.yaml
oc3 export poddisruptionbudget --as-template=%oc3_projectname%-poddisruptionbudget > %oc3_projectname%-poddisruptionbudget.yaml
oc3 export endpoints --as-template=%oc3_projectname%-endpoints > %oc3_projectname%-endpoints.yaml

REM ### Get back to parent directory for next stage ###
cd ..

REM ##### Openshift 3 Test ######
cd %oc3_projectname%-test
oc3 project %oc3_ns%-test

REM ### Get the legacy main object backup (RAW) ###
oc3 get -o yaml --export all > %oc3_projectname%-rawbackup.yaml

REM Backup discrete kubernetes templates by object type
oc3 export pods --as-template=%oc3_projectname%-pods > %oc3_projectname%-pods.yaml
oc3 export replicationcontrollers --as-template=%oc3_projectname%-replicationcontrollers > %oc3_projectname%-replicationcontrollers.yaml
oc3 export services --as-template=%oc3_projectname%-services > %oc3_projectname%-services.yaml
oc3 export deploymentconfigs --as-template=%oc3_projectname%-deploymentconfigs > %oc3_projectname%-deploymentconfigs.yaml
oc3 export buildconfigs --as-template=%oc3_projectname%-buildconfigs > %oc3_projectname%-buildconfigs.yaml
oc3 export builds --as-template=%oc3_projectname%-builds > %oc3_projectname%-builds.yaml
oc3 export imagestreams --as-template=%oc3_projectname%-imagestreams > %oc3_projectname%-imagestreams.yaml
oc3 export routes --as-template=%oc3_projectname%-routes > %oc3_projectname%-routes.yaml
oc3 export rolebindings --as-template=%oc3_projectname%-rolebindings > %oc3_projectname%-rolebindings.yaml
oc3 export serviceaccounts --as-template=%oc3_projectname%-serviceaccounts > %oc3_projectname%-serviceaccounts.yaml
oc3 export secrets --as-template=%oc3_projectname%-secrets > %oc3_projectname%-secrets.yaml
oc3 export imagestreamtags --as-template=%oc3_projectname%-imagestreamtags > %oc3_projectname%-imagestreamtags.yaml
oc3 export cm --as-template=%oc3_projectname%-cm > %oc3_projectname%-cm.yaml
oc3 export egressnetworkpolicies --as-template=%oc3_projectname%-egressnetworkpolicies > %oc3_projectname%-egressnetworkpolicies.yaml
oc3 export rolebindingrestrictions --as-template=%oc3_projectname%-rolebindingrestrictions > %oc3_projectname%-rolebindingrestrictions.yaml
oc3 export limitranges --as-template=%oc3_projectname%-limitranges > %oc3_projectname%-limitranges.yaml
oc3 export resourcequotas --as-template=%oc3_projectname%-resourcequotas > %oc3_projectname%-resourcequotas.yaml
oc3 export pvc --as-template=%oc3_projectname%-pvc > %oc3_projectname%-pvc.yaml
oc3 export templates --as-template=%oc3_projectname%-templates > %oc3_projectname%-templates.yaml
oc3 export cronjobs --as-template=%oc3_projectname%-cronjobs > %oc3_projectname%-cronjobs.yaml
oc3 export statefulsets --as-template=%oc3_projectname%-statefulsets > %oc3_projectname%-statefulsets.yaml
oc3 export hpa --as-template=%oc3_projectname%-hpa > %oc3_projectname%-hpa.yaml
oc3 export deployments --as-template=%oc3_projectname%-deployments > %oc3_projectname%-deployments.yaml
oc3 export replicasets --as-template=%oc3_projectname%-replicasets > %oc3_projectname%-replicasets.yaml
oc3 export poddisruptionbudget --as-template=%oc3_projectname%-poddisruptionbudget > %oc3_projectname%-poddisruptionbudget.yaml
oc3 export endpoints --as-template=%oc3_projectname%-endpoints > %oc3_projectname%-endpoints.yaml

REM ### Get back to parent directory for next stage ###
cd ..

REM ##### Openshift 3 Prod ######
cd %oc3_projectname%-prod
oc3 project %oc3_ns%-prod

REM ### Get the legacy main object backup (RAW) ###
oc3 get -o yaml --export all > %oc3_projectname%-rawbackup.yaml

REM ### Backup discrete kubernetes templates by object type ###
oc3 export pods --as-template=%oc3_projectname%-pods > %oc3_projectname%-pods.yaml
oc3 export replicationcontrollers --as-template=%oc3_projectname%-replicationcontrollers > %oc3_projectname%-replicationcontrollers.yaml
oc3 export services --as-template=%oc3_projectname%-services > %oc3_projectname%-services.yaml
oc3 export deploymentconfigs --as-template=%oc3_projectname%-deploymentconfigs > %oc3_projectname%-deploymentconfigs.yaml
oc3 export buildconfigs --as-template=%oc3_projectname%-buildconfigs > %oc3_projectname%-buildconfigs.yaml
oc3 export builds --as-template=%oc3_projectname%-builds > %oc3_projectname%-builds.yaml
oc3 export imagestreams --as-template=%oc3_projectname%-imagestreams > %oc3_projectname%-imagestreams.yaml
oc3 export routes --as-template=%oc3_projectname%-routes > %oc3_projectname%-routes.yaml
oc3 export rolebindings --as-template=%oc3_projectname%-rolebindings > %oc3_projectname%-rolebindings.yaml
oc3 export serviceaccounts --as-template=%oc3_projectname%-serviceaccounts > %oc3_projectname%-serviceaccounts.yaml
oc3 export secrets --as-template=%oc3_projectname%-secrets > %oc3_projectname%-secrets.yaml
oc3 export imagestreamtags --as-template=%oc3_projectname%-imagestreamtags > %oc3_projectname%-imagestreamtags.yaml
oc3 export cm --as-template=%oc3_projectname%-cm > %oc3_projectname%-cm.yaml
oc3 export egressnetworkpolicies --as-template=%oc3_projectname%-egressnetworkpolicies > %oc3_projectname%-egressnetworkpolicies.yaml
oc3 export rolebindingrestrictions --as-template=%oc3_projectname%-rolebindingrestrictions > %oc3_projectname%-rolebindingrestrictions.yaml
oc3 export limitranges --as-template=%oc3_projectname%-limitranges > %oc3_projectname%-limitranges.yaml
oc3 export resourcequotas --as-template=%oc3_projectname%-resourcequotas > %oc3_projectname%-resourcequotas.yaml
oc3 export pvc --as-template=%oc3_projectname%-pvc > %oc3_projectname%-pvc.yaml
oc3 export templates --as-template=%oc3_projectname%-templates > %oc3_projectname%-templates.yaml
oc3 export cronjobs --as-template=%oc3_projectname%-cronjobs > %oc3_projectname%-cronjobs.yaml
oc3 export statefulsets --as-template=%oc3_projectname%-statefulsets > %oc3_projectname%-statefulsets.yaml
oc3 export hpa --as-template=%oc3_projectname%-hpa > %oc3_projectname%-hpa.yaml
oc3 export deployments --as-template=%oc3_projectname%-deployments > %oc3_projectname%-deployments.yaml
oc3 export replicasets --as-template=%oc3_projectname%-replicasets > %oc3_projectname%-replicasets.yaml
oc3 export poddisruptionbudget --as-template=%oc3_projectname%-poddisruptionbudget > %oc3_projectname%-poddisruptionbudget.yaml
oc3 export endpoints --as-template=%oc3_projectname%-endpoints > %oc3_projectname%-endpoints.yaml
cd ..

REM #### Logging out of Openshift 3 ####
oc3 logout

REM #### Collect Openshift 4 Parameters ####
set /p oc4_token=Openshift 4 Login Token:
set /p oc4_ns=Openshift License Plate:

oc4 login --token=%oc4_token% --server=https://api.silver.devops.gov.bc.ca:6443


REM ##### Move to Openshift 3 Tools Export Directory #####

oc4 project %oc4_ns%-tools


REM ### Import Tools First ###
cd %oc3_projectname%-tools
REM ##### Process and Create Build Configs #####
oc4 process -f %oc3_projectname%-buildconfigs.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create ImageStreams #####
oc4 process -f %oc3_projectname%-imagestreams.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create services #####
oc4 process -f %oc3_projectname%-services.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create ConfigMaps #####
oc4 process -f %oc3_projectname%-cm.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create Secrets #####
oc4 process -f %oc3_projectname%-secrets.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create egressnetworkpolicies #####
oc4 process -f %oc3_projectname%-egressnetworkpolicies.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create statefulsets #####
oc4 process -f %oc3_projectname%-statefulsets.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create cronjobs #####
oc4 process -f %oc3_projectname%-cronjobs.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create serviceaccounts #####
oc4 process -f %oc3_projectname%-serviceaccounts.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create rolebindings #####
oc4 process -f %oc3_projectname%-rolebindings.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
######REM ##### Process and Create endpoints #####
######oc4 process -f %oc3_projectname%-endpoints.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create deploymentconfigs #####
oc4 process -f %oc3_projectname%-deploymentconfigs.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
###REM ##### Process and Create replicationcontrollers #####
###oc4 process -f %oc3_projectname%-replicationcontrollers.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create builds #####
oc4 process -f %oc3_projectname%-builds.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
######REM ##### Process and Createimagestreamtags #####
######oc4 process -f %oc3_projectname%-imagestreamtags.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create rolebindingrestrictions #####
oc4 process -f %oc3_projectname%-rolebindingrestrictions.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
###REM ##### Process and Create limitranges #####
###oc4 process -f %oc3_projectname%-limitranges.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
###REM ##### Process and Create resourcequotas #####
###oc4 process -f %oc3_projectname%-resourcequotas.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create pvc #####
oc4 process -f %oc3_projectname%-pvc.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create hpa #####
oc4 process -f %oc3_projectname%-hpa.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create templates #####
oc4 process -f %oc3_projectname%-templates.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create deployments #####
oc4 process -f %oc3_projectname%-deployments.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create replicasets #####
oc4 process -f %oc3_projectname%-replicasets.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create poddisruptionbudget #####
oc4 process -f %oc3_projectname%-poddisruptionbudget.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -
REM ##### Process and Create pods #####
oc4 process -f %oc3_projectname%-pods.yaml -l migration=%oc3_projectname%-migration-template | oc4 create -f -

### REM Press Enter to Rollback, or CTRL-C and Y to quit, (Rollback is not for all objects yet)
pause

oc4 delete all --selector migration=%oc3_projectname%-migration-template

REM #### Logout of Openshift 4 ####
oc4 logout
