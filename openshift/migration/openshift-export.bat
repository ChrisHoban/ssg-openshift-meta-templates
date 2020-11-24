@echo on

REM collect the params
set /p token=Openshift Login Token:
set /p ns=Openshift Namespace:
set /p projectname=Project Name:

oc login https://console.pathfinder.gov.bc.ca:8443 --token=%token%

REM create all the dirs
mkdir %projectname%-export
cd %projectname%-export
mkdir %projectname%-tools
mkdir %projectname%-dev
mkdir %projectname%-test
mkdir %projectname%-prod

REM ##### TOOLS ######
cd %projectname%-tools
oc project %ns%-tools

REM Get the legacy main object backup (RAW)
oc get -o yaml --export all > %projectname%-rawbackup.yaml

oc get services --export > services

REM Backup discrete kubernetes templates by object type
oc export pods --as-template=%projectname%-pods > %projectname%-pods.yaml
oc export replicationcontrollers --as-template=%projectname%-replicationcontrollers > %projectname%-replicationcontrollers.yaml
oc export services --as-template=%projectname%-services > %projectname%-services.yaml
oc export deploymentconfigs --as-template=%projectname%-deploymentconfigs > %projectname%-deploymentconfigs.yaml
oc export buildconfigs --as-template=%projectname%-buildconfigs > %projectname%-buildconfigs.yaml
oc export builds --as-template=%projectname%-builds > %projectname%-builds.yaml
oc export imagestreams --as-template=%projectname%-imagestreams > %projectname%-imagestreams.yaml
oc export routes --as-template=%projectname%-routes > %projectname%-routes.yaml
oc export rolebindings --as-template=%projectname%-rolebindings > %projectname%-rolebindings.yaml
oc export serviceaccounts --as-template=%projectname%-serviceaccounts > %projectname%-serviceaccounts.yaml
oc export secrets --as-template=%projectname%-secrets > %projectname%-secrets.yaml
oc export imagestreamtags --as-template=%projectname%-imagestreamtags > %projectname%-imagestreamtags.yaml
oc export cm --as-template=%projectname%-cm > %projectname%-cm.yaml
oc export egressnetworkpolicies --as-template=%projectname%-egressnetworkpolicies > %projectname%-egressnetworkpolicies.yaml
oc export rolebindingrestrictions --as-template=%projectname%-rolebindingrestrictions > %projectname%-rolebindingrestrictions.yaml
oc export limitranges --as-template=%projectname%-limitranges > %projectname%-limitranges.yaml
oc export resourcequotas --as-template=%projectname%-resourcequotas > %projectname%-resourcequotas.yaml
oc export pvc --as-template=%projectname%-pvc > %projectname%-pvc.yaml
oc export templates --as-template=%projectname%-templates > %projectname%-templates.yaml
oc export cronjobs --as-template=%projectname%-cronjobs > %projectname%-cronjobs.yaml
oc export statefulsets --as-template=%projectname%-statefulsets > %projectname%-statefulsets.yaml
oc export hpa --as-template=%projectname%-hpa > %projectname%-hpa.yaml
oc export deployments --as-template=%projectname%-deployments > %projectname%-deployments.yaml
oc export replicasets --as-template=%projectname%-replicasets > %projectname%-replicasets.yaml
oc export poddisruptionbudget --as-template=%projectname%-poddisruptionbudget > %projectname%-poddisruptionbudget.yaml
oc export endpoints --as-template=%projectname%-endpoints > %projectname%-endpoints.yaml

REM Get back to parent directory for next stage
cd ..

REM ##### DEV ######
cd %projectname%-dev
oc project %ns%-dev

REM Get the legacy main object backup (RAW)
oc get -o yaml --export all > %projectname%-rawbackup.yaml

REM Backup discrete kubernetes templates by object type
oc export pods --as-template=%projectname%-pods > %projectname%-pods.yaml
oc export replicationcontrollers --as-template=%projectname%-replicationcontrollers > %projectname%-replicationcontrollers.yaml
oc export services --as-template=%projectname%-services > %projectname%-services.yaml
oc export deploymentconfigs --as-template=%projectname%-deploymentconfigs > %projectname%-deploymentconfigs.yaml
oc export buildconfigs --as-template=%projectname%-buildconfigs > %projectname%-buildconfigs.yaml
oc export builds --as-template=%projectname%-builds > %projectname%-builds.yaml
oc export imagestreams --as-template=%projectname%-imagestreams > %projectname%-imagestreams.yaml
oc export routes --as-template=%projectname%-routes > %projectname%-routes.yaml
oc export rolebindings --as-template=%projectname%-rolebindings > %projectname%-rolebindings.yaml
oc export serviceaccounts --as-template=%projectname%-serviceaccounts > %projectname%-serviceaccounts.yaml
oc export secrets --as-template=%projectname%-secrets > %projectname%-secrets.yaml
oc export imagestreamtags --as-template=%projectname%-imagestreamtags > %projectname%-imagestreamtags.yaml
oc export cm --as-template=%projectname%-cm > %projectname%-cm.yaml
oc export egressnetworkpolicies --as-template=%projectname%-egressnetworkpolicies > %projectname%-egressnetworkpolicies.yaml
oc export rolebindingrestrictions --as-template=%projectname%-rolebindingrestrictions > %projectname%-rolebindingrestrictions.yaml
oc export limitranges --as-template=%projectname%-limitranges > %projectname%-limitranges.yaml
oc export resourcequotas --as-template=%projectname%-resourcequotas > %projectname%-resourcequotas.yaml
oc export pvc --as-template=%projectname%-pvc > %projectname%-pvc.yaml
oc export templates --as-template=%projectname%-templates > %projectname%-templates.yaml
oc export cronjobs --as-template=%projectname%-cronjobs > %projectname%-cronjobs.yaml
oc export statefulsets --as-template=%projectname%-statefulsets > %projectname%-statefulsets.yaml
oc export hpa --as-template=%projectname%-hpa > %projectname%-hpa.yaml
oc export deployments --as-template=%projectname%-deployments > %projectname%-deployments.yaml
oc export replicasets --as-template=%projectname%-replicasets > %projectname%-replicasets.yaml
oc export poddisruptionbudget --as-template=%projectname%-poddisruptionbudget > %projectname%-poddisruptionbudget.yaml
oc export endpoints --as-template=%projectname%-endpoints > %projectname%-endpoints.yaml

REM Get back to parent directory for next stage
cd ..

REM ##### TEST ######
cd %projectname%-test
oc project %ns%-test

REM Get the legacy main object backup (RAW)
oc get -o yaml --export all > %projectname%-rawbackup.yaml

REM Backup discrete kubernetes templates by object type
oc export pods --as-template=%projectname%-pods > %projectname%-pods.yaml
oc export replicationcontrollers --as-template=%projectname%-replicationcontrollers > %projectname%-replicationcontrollers.yaml
oc export services --as-template=%projectname%-services > %projectname%-services.yaml
oc export deploymentconfigs --as-template=%projectname%-deploymentconfigs > %projectname%-deploymentconfigs.yaml
oc export buildconfigs --as-template=%projectname%-buildconfigs > %projectname%-buildconfigs.yaml
oc export builds --as-template=%projectname%-builds > %projectname%-builds.yaml
oc export imagestreams --as-template=%projectname%-imagestreams > %projectname%-imagestreams.yaml
oc export routes --as-template=%projectname%-routes > %projectname%-routes.yaml
oc export rolebindings --as-template=%projectname%-rolebindings > %projectname%-rolebindings.yaml
oc export serviceaccounts --as-template=%projectname%-serviceaccounts > %projectname%-serviceaccounts.yaml
oc export secrets --as-template=%projectname%-secrets > %projectname%-secrets.yaml
oc export imagestreamtags --as-template=%projectname%-imagestreamtags > %projectname%-imagestreamtags.yaml
oc export cm --as-template=%projectname%-cm > %projectname%-cm.yaml
oc export egressnetworkpolicies --as-template=%projectname%-egressnetworkpolicies > %projectname%-egressnetworkpolicies.yaml
oc export rolebindingrestrictions --as-template=%projectname%-rolebindingrestrictions > %projectname%-rolebindingrestrictions.yaml
oc export limitranges --as-template=%projectname%-limitranges > %projectname%-limitranges.yaml
oc export resourcequotas --as-template=%projectname%-resourcequotas > %projectname%-resourcequotas.yaml
oc export pvc --as-template=%projectname%-pvc > %projectname%-pvc.yaml
oc export templates --as-template=%projectname%-templates > %projectname%-templates.yaml
oc export cronjobs --as-template=%projectname%-cronjobs > %projectname%-cronjobs.yaml
oc export statefulsets --as-template=%projectname%-statefulsets > %projectname%-statefulsets.yaml
oc export hpa --as-template=%projectname%-hpa > %projectname%-hpa.yaml
oc export deployments --as-template=%projectname%-deployments > %projectname%-deployments.yaml
oc export replicasets --as-template=%projectname%-replicasets > %projectname%-replicasets.yaml
oc export poddisruptionbudget --as-template=%projectname%-poddisruptionbudget > %projectname%-poddisruptionbudget.yaml
oc export endpoints --as-template=%projectname%-endpoints > %projectname%-endpoints.yaml

REM Get back to parent directory for next stage
cd ..

REM ##### prod ######
cd %projectname%-prod
oc project %ns%-prod

REM Get the legacy main object backup (RAW)
oc get -o yaml --export all > %projectname%-rawbackup.yaml

REM Backup discrete kubernetes templates by object type
oc export pods --as-template=%projectname%-pods > %projectname%-pods.yaml
oc export replicationcontrollers --as-template=%projectname%-replicationcontrollers > %projectname%-replicationcontrollers.yaml
oc export services --as-template=%projectname%-services > %projectname%-services.yaml
oc export deploymentconfigs --as-template=%projectname%-deploymentconfigs > %projectname%-deploymentconfigs.yaml
oc export buildconfigs --as-template=%projectname%-buildconfigs > %projectname%-buildconfigs.yaml
oc export builds --as-template=%projectname%-builds > %projectname%-builds.yaml
oc export imagestreams --as-template=%projectname%-imagestreams > %projectname%-imagestreams.yaml
oc export routes --as-template=%projectname%-routes > %projectname%-routes.yaml
oc export rolebindings --as-template=%projectname%-rolebindings > %projectname%-rolebindings.yaml
oc export serviceaccounts --as-template=%projectname%-serviceaccounts > %projectname%-serviceaccounts.yaml
oc export secrets --as-template=%projectname%-secrets > %projectname%-secrets.yaml
oc export imagestreamtags --as-template=%projectname%-imagestreamtags > %projectname%-imagestreamtags.yaml
oc export cm --as-template=%projectname%-cm > %projectname%-cm.yaml
oc export egressnetworkpolicies --as-template=%projectname%-egressnetworkpolicies > %projectname%-egressnetworkpolicies.yaml
oc export rolebindingrestrictions --as-template=%projectname%-rolebindingrestrictions > %projectname%-rolebindingrestrictions.yaml
oc export limitranges --as-template=%projectname%-limitranges > %projectname%-limitranges.yaml
oc export resourcequotas --as-template=%projectname%-resourcequotas > %projectname%-resourcequotas.yaml
oc export pvc --as-template=%projectname%-pvc > %projectname%-pvc.yaml
oc export templates --as-template=%projectname%-templates > %projectname%-templates.yaml
oc export cronjobs --as-template=%projectname%-cronjobs > %projectname%-cronjobs.yaml
oc export statefulsets --as-template=%projectname%-statefulsets > %projectname%-statefulsets.yaml
oc export hpa --as-template=%projectname%-hpa > %projectname%-hpa.yaml
oc export deployments --as-template=%projectname%-deployments > %projectname%-deployments.yaml
oc export replicasets --as-template=%projectname%-replicasets > %projectname%-replicasets.yaml
oc export poddisruptionbudget --as-template=%projectname%-poddisruptionbudget > %projectname%-poddisruptionbudget.yaml
oc export endpoints --as-template=%projectname%-endpoints > %projectname%-endpoints.yaml

cd ..
cd ..
REM Operation Complete! Press enter to exit
pause
