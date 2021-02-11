# OpenShift Meta Template

OpenShift Meta Template is an effort to bootstrap in a full [openshift](https://www.openshift.com) build pipeline in the [BCGov](https://github.com/bcgov) space with minimal upfront effort. The idea is being able to configure everything upfront and have what you need get spun up and created quickly. Really handy in MicroService development.

[![N|Solid](https://github.com/ChrisHoban/ssg-openshift-meta-templates/raw/master/OpenShift-DevOps-Flow.png)](https://github.com/ChrisHoban/ssg-openshift-meta-templates/raw/master/OpenShift-DevOps-Flow.png)

Features includes:

- Build S2I from standard `nodeJS`/`.NET`/`Java` source code repository
- Setup for Infrastructure As Code, but will create BuildConfig/DeploymentConfig/Route/Service objects if they don't yet exist in your repo
- Configure Build and Deployment pod Resources (Time Limited Resource Pool)
- LifeCycle Webhook used to deliver caught Pipeline Exceptions

## Getting Started/Pre Requisites

### Installing Jenkins
Deploy a jenkins server using `BC Gov Pathfinder Jenkins (Persistent)` image from the service catalog.

* After deploying be sure to edit the jenkins deployment config and adjust the volume mounts as per the [directions in BC Developer Hub](https://developer.gov.bc.ca/Migrating-Your-BC-Gov-Jenkins-to-the-Cloud)

### Adding The Required Role Bindings
Click import YAML (Plus Icon in top right) in openshift tools namespace

paste [contents](https://raw.githubusercontent.com/ChrisHoban/ssg-openshift-meta-templates/master/openshift/oc4-meta-templates/jenkins-role-bindings.yaml) of /openshift/oc4-meta-templates/pipeline-build-template.yaml

* Under Development mode, click +Add on the upper left
* Choose "From Catalog"
* Search for Jenkins and select "Jenkins Role Bindings"
* Click Instantiate Template
* Fill in the licenseplate for the project, it should create 6 Rolebindings, 3 in tools and 1 each in dev/test/prod

### If you're building a Dotnet application, deploy the appropriate Jenkins slave:
- [dotnet core](openshift/oc4-meta-templates/build-slaves/dotnet-slave.yaml)


### Add the Master Pipeline Template to your tools namespace
Click import YAML (Plus Icon in top right) in openshift tools namespace

paste [contents](https://raw.githubusercontent.com/ChrisHoban/ssg-openshift-meta-templates/master/openshift/oc4-meta-templates/pipeline-build-template.yaml) of /openshift/oc4-meta-templates/pipeline-build-template.yaml

## Steps to get each application pipeline created/building/deploying after finishing the above pre reqs

* Under Development mode, click +Add on the upper left
* Choose "From Catalog"
* Search for Jenkins and select "Master Pipeline Template"
* Click Instantiate Template
* Fill in the required fields such as github repository, and name of the service/app



## Upcoming Features!

- SonarQube scanning for any project
- LifeCycle WebHooks
- HealthCheck Configs
- One Time Bootstrap Tools Services
      - Deploy and Configure Jenkins
      - Deploy and Configure SonarQube
      - Network Security Policy Configuration
      - image puller role for dev/test/prod namespace default user for tools namespace imagestream deployments

## Notes

- Current tool requires the following is already done before it works (Future versions will work on a blank slate):
  1. Persistent Jenkins Template installed
  2. Network Security Policies loosened (Template to do so contained within)


- Pipeline build comes with jenkinsfile inline, for rapid prototyping before eventually placing pipeline in your repository.

## Contributing

If you want to discuss a new feature or found a bug, please open a new [issue here](https://github.com/ChrisHoban/ssg-openshift-meta-templates/issues).
