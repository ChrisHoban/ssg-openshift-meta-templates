# Docker Imagestream Deployer
This script and template is meant to allow you to quickly import a local imagestream in OpenShift that is populated by any dockerimage and uses a dockerhub credential to avoid platform docker pull rate limit issues.

## Installation
### 1 Run Installer

Pre Requisites:
* Docker Hub Username and credentials
* OpenShift Namespace to deploy into
* Valid OpenShift Login token


```
./docker-imagestream.sh
```


[![N|Solid](https://github.com/ChrisHoban/ssg-openshift-meta-templates/blob/master/local_docker_image_script.PNG)](https://github.com/ChrisHoban/ssg-openshift-meta-templates/blob/master/openshift/oc4-meta-templates/scripts/local_docker_image_script.PNG)
