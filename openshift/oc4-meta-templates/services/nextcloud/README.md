# Nextcloud OpenShift Deployment

The goal of this set of templates and scripts is to rapidly deploy a Nextcloud Cluster that adheres to BC Gov standard Namespace conventions. It deploys builders and imagestreams to Tools as first time run, and deploys Nextcloud and MariaDB including Deployment Configs/services/Routes/Secrets/ConfigMaps/PVCs/CronJobs to the appropriate environment (dev/test/prod). Some additions to a standard docker image based nextcloud install:

* Uses supplied DockerHub Credentials to avoid docker pull rate failures on 3 source DockerImages (Nginx/MariaDB,Nextcloud)
* Fronted by Nginx rather than Apache
* Builder + Dockerfile strategy to customize the final Nextcloud container image composition and configuration
* A continuation of work done by (https://github.com/tobru) and (https://github.com/agahchen)


[![N|Solid](https://github.com/ChrisHoban/ssg-openshift-meta-templates/blob/master/NextcloudOpenShiftDeployment.png)](https://github.com/ChrisHoban/ssg-openshift-meta-templates/blob/master/openshift/oc4-meta-templates/services/nextcloud/NextcloudOpenShiftDeployment.png)


## Installation


### 1 Run Installer

Pre Requisites:
* Docker Hub Username and credentials
* OpenShift Namespace to deploy into
* Valid OpenShift Login token
* first_time_run variable default to 1 (true), sets up imagestreams in tools first time.


```
./nextcloud.sh
```


[![N|Solid](https://github.com/ChrisHoban/ssg-openshift-meta-templates/blob/master/nextcloud-installer.png)](https://github.com/ChrisHoban/ssg-openshift-meta-templates/blob/master/openshift/oc4-meta-templates/services/nextcloud/nextcloud-installer.png)


### 2 Configure Nextcloud

* Navigate to http://nextcloud.example.com
* Fill in the form and finish the installation. The DB credentials can be
  found in the secret `mysql`. In the Webconsole it can be found under
  `Resources -> Secrets -> mysql -> Reveal Secret`

**Hints**

* You might want to enable TLS for your instance

## Backup

### Database

You can use the provided DB dump `CronJob` template:

```
oc process -f https://raw.githubusercontent.com/ChrisHoban/ssg-openshift-meta-templates/master/openshift/oc4-meta-templates/services/nextcloud/mariadb-backup.yaml | oc -n MYNAMESPACE create -f -
```

This script dumps the DB to the same PV as the database stores it's data.
You must make sure that you copy these files away to a real backup location.

### Files

To backup files, a simple solution would be to run f.e. [restic](http://restic.readthedocs.io/) in a Pod
as a `CronJob` and mount the PVCs as volumes. Then use an S3 endpoint for restic
to backup data to.

## Notes

* Nextcloud Cronjob is called from a `CronJob` object every 15 minutes
* The Dockerfile just add the `nginx.conf` to the Alpine Nginx container

To use the `occ` CLI, you can use `oc exec`:

```
oc get pods
oc exec NEXTCLOUDPOD -c nextcloud -ti php occ
```

## Ideas

* Autoconfigure Nextcloud using `autoconfig.php`
* Provide restic Backup example


#### Template parameters

Execute the following command to get the available parameters:

```
oc process -f https://raw.githubusercontent.com/ChrisHoban/ssg-openshift-meta-templates/master/openshift/oc4-meta-templates/services/nextcloud/nextcloud.yaml --parameters
```
