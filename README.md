# OpenShift Meta Template

OpenShift Meta Template is an effort to bootstrap in a full [openshift](https://www.openshift.com) build pipeline in the [BCGov](https://github.com/bcgov) space with minimal upfront effort. The idea is being able to configure everything upfront and have what you need get spun up and created. Really handy in MicroService development.

[![N|Solid](OpenShift-DevOps-Flow.png)](OpenShift-DevOps-Flow.png)

Features includes:

- Build S2I from standard `nodeJS`/`.NET`/`Java` source code repository
- Setup for Infrastructure As Code, but will create BuildConfig/DeploymentConfig/Route/Service objects if they don't yet exist in your repo
- Configure Build and Deployment pod Resources (Time Limited Resource Pool)
- LifeCycle Webhook used to deliver caught Pipeline Exceptions

## Getting Started

Deploy a jenkins server using `BC Gov Pathfinder Jenkins (Persistent)` image from the service catalog.

Click import YAML in openshift tools namespace

paste [contents](https://raw.githubusercontent.com/ChrisHoban/ssg-openshift-meta-templates/master/openshift/meta-templates/pipeline-build-template.yaml) of /openshift/meta-templates/pipeline-build-template.yaml

Fill out requested parameters 

### Deploy a dotnet core web application

> This instructions are for dotnet core 3.1 only


  

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
  3. default user for dev/test/prod has image:puller role in tools namespace

- Pipeline build comes with jenkinsfile inline, for rapid prototyping before eventually placing pipeline in your repository.

## Contributing

If you want to discuss a new feature or found a bug, please open a new [issue here](https://github.com/ChrisHoban/ssg-openshift-meta-templates/issues).
