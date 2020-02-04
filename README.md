# OpenShift Meta Template

(OpenShift-DevOps-Flow.png)
OpenShift Meta Template is an effort to bootstrap in a full openshift build pipeline in the BCGov space with minimal upfront effort. The idea is being able to configure everything upfront and have what you need get spun up and created. Really handy in MicroService development.

Current Features
  - Build from standard nodeJS/.NET/Java source code repository
  - Setup for Infrastructure As Code, but will create BuildConfig/DeploymentConfig/Route/Service objects if they don't yet exist in your repo
  - Configure Build and Deployment Resources (Time Limited Resource Pool)

# Upcoming Features!

  - SonarQube scanning for any project
  - LifeCycle WebHooks
  - HealthCheck Configs
  - One Time Bootstrap Tools Services
        - Deploy and Configure Jenkins
        - Deploy and Configure SonarQube
        - Network Security Policy Configuration
        - image puller role for dev/test/prod namespace default user for tools namespace imagestream deployments

**How to Use**
1. Click import YAML in openshift tools namespace
2. paste contents of /openshift/meta-templates/pipeline-build-template.yaml
3. Fill out requested parameters 



**Notes**

- Current tool requires the following is already done before it works (Future versions will work on a blank slate): 
   1. Persistent Jenkins Template installed
   2. Network Security Policies loosened (Template to do so contained within)
   3. default user for dev/test/prod has image:puller role in tools namespace
 
- Pipeline build comes with jenkinsfile inline, for rapid prototyping before eventually placing pipeline in your repository.

_Upcoming features and tracked issues:_ https://github.com/ChrisHoban/ssg-openshift-meta-templates/issues  
