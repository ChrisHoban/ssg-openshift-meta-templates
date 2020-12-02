# OpenShift3 to OpenShift4 CLI Migration tool

OpenShift 3 to OpenShift 4 migration tool is a simple approach to use the OC3 CLI and OC4 CLI to export templated kubernetes objects (With namespace state removed) from OC3 Pathfinder project namespaces (tools, dev, test, prod) for one project to the local filesystem, then Import these Kubernetes objects into OC4. It is in its early stages and will likely not cover an entire project migration. What its goal is, is to automate the tedium and start your OC4 namespace with specific builds, buildconfigs, deploymentconfigs, configmaps, secrets all populated. The idea is that the effort becomes restoring build pipelines in Tools with what is moved accross, such that real builds and deployments can be done to roll everything to a working state straight to Prod.


## Getting Started/Pre requisites

- Requires both OpenShift 3 CLI and the OpenShift 4 Cli
  - find oc3 cli (use your path environment variable if you forgot)
  - Rename to oc3.
  - Install OC4 CLI, in a new location.
  - Rename the binary to oc4, make sure its also in your path environment variable


## Notes

- Work in progress, may already provide value, but several object translation and a cleaner generation of services like Jenkins is in progress. This all may soon move to Ansible as well, though for now the .bat file approach is generally the lowest barrier to entry for now.

** This does pull down your secrets to the local filesystem, in a later version these will be removed on successful import **
