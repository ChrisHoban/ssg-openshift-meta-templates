#!/bin/bash

# Hide trace of commands
set +x
set -e

####
#
#   Used to extract openshift 3 (oc or oc3) objects and saves them as files.
#   It initlally downloads each object as seperate files
#   then validates by downloading the entire namespace
#   and compares the outputes to ensure they're are the same
#
#   ** WARNING: This blindly overwrites the destination files on each run.
#   ** CAUTION: This exports the oc secrets - DO NOT COMMIT SECRETS TO GIT!
#
####

PROGNAME=$0

usage() {
    cat << EOF >&2
Usage: $PROGNAME [-t] [-l] [-p]

-t <loginhash> : (required) obtain the token from the opensift account found here: "(?) Help -> About -> Command Line Tools"
-l <prefix>    : (required) this is the prefix or license plate of the requested namespace.  Can be obtained from command: "oc3 get projects"
-p <project>   : (required) arbitrary project name used for outputing labeling the exported folder/files
-d <boolean>   : (optional) turn of debug by passing in an integer 1-9 (default 0 = off)
EOF
    exit 1
}

checkEnv() {
    if [ -z "$OC3_TOKEN" ] || [ -z "$OC3_LICENSEPLATE" ] || [ -z "$PROJECT" ] || [ -z "$OC3_ENVIRONMENT" ]; then
        usage
    else
        oc3_token="${OC3_TOKEN}"
        licenseplate="${OC3_LICENSEPLATE}"
        projectname="${PROJECT}"
        debug="${DEBUG}"
        # This explodes the ENVIRONMENT string (passed in as an environment variable) into an array
        environments=(${OC3_ENVIRONMENT//,/ })
    fi
}

getParms() {
    debug=0
    echo "### Obtain passed in paramaters ###"
    # There's an assumption that if one paramater is passed in that all are expected and no environment variables will be considered.
    if [ -z "$1" ]; then
        checkEnv
    else
        while getopts ":t:l:p:d:e:" option; do
            case ${option} in
                t) oc3_token=$OPTARG;;
                l) licenseplate=$OPTARG;;
                p) projectname=$OPTARG;;
                d) debug=$OPTARG;;
                e) environments=$OPTARG;;
                *) usage;;
            esac
        done
        shift "$((OPTIND -1))"
    fi

    if [[ $debug > 0 ]]; then
        set -x  # turn off trace of commands
        echo "oc3_token is: $oc3_token"
        echo "licenseplate is: $licenseplate"
        echo "projectname is: $projectname"
        echo Remaining arguments: "$@"
    fi
}

ocLogin() {
    echo "### Logging into Openshift 3 ###"

    if [ ! -f "./oc3" ]; then
        # download the OpenShift CLI for openshift3 - since this is now a mounted volume, it'll only download to the workstation the first time.
        wget https://nttdata-canada.s3.ca-central-1.amazonaws.com/oc3
        chmod +rx ./oc3
    fi

    # TODO: Do we need this anymore?
    if ! command -v ./oc3 &> /dev/null; then
        echo "oc3 command doesn't exist.  Install oc and symlink oc3->oc. eg: 'ln -s /usr/local/bin/oc /usr/local/bin/oc3'"
        exit 1
    fi

    echo ###### LOGIN TO OC3 ########
    ./oc3 login https://console.pathfinder.gov.bc.ca:8443 --token=${oc3_token}
}

ocLogout() {
    echo "### Logging out of Openshift 3 ###"
    ./oc3 logout
}

processExport() {
    echo "### Export objects from Openshift 3 ###"

    environments=$1
    
    kubernetes_obj=()
    kubernetes_obj+=('builds')
    kubernetes_obj+=('buildconfigs')
    kubernetes_obj+=('cm')
    kubernetes_obj+=('cronjobs')
    kubernetes_obj+=('deploymentconfigs')
    kubernetes_obj+=('deployments')
    #kubernetes_obj+=('egressnetworkpolicies')
    kubernetes_obj+=('endpoints')
    kubernetes_obj+=('hpa')
    kubernetes_obj+=('imagestreamtags')
    kubernetes_obj+=('imagestreams')
    kubernetes_obj+=('limitranges')
    kubernetes_obj+=('poddisruptionbudget')
    kubernetes_obj+=('pods')
    kubernetes_obj+=('pvc')
    kubernetes_obj+=('replicasets')
    kubernetes_obj+=('replicationcontrollers')
    kubernetes_obj+=('resourcequotas')
    #kubernetes_obj+=('rolebindingrestrictions')
    #kubernetes_obj+=('rolebindings')
    kubernetes_obj+=('routes')
    # Yes, we're exporting secrets.  This is being exported by the omnimanifest so the cat is already out of the bag.
    # *** DO NOT COMMIT THIS FILE TO GIT!!! ***
    kubernetes_obj+=('secrets')
    kubernetes_obj+=('serviceaccounts')
    kubernetes_obj+=('services')
    kubernetes_obj+=('statefulsets')
    kubernetes_obj+=('templates')

    for env in ${environments[@]}; do
        # TODO: we're making the directory before we know we have access to it.  Good idea to test access to the namespace before creating the directory
        location=$projectname-$licenseplate/$env
        mkdir -p $location

        #Move into the correct namespace
        ./oc3 project $licenseplate-$env

        echo "Get the omnimanifest object (RAW) for $licenseplate-$env"

        # Yes, this will export secrets. I don't know a way around this yet.
        # *** DO NOT COMMIT THIS FILE TO GIT!!! ***
        ./oc3 get -o yaml all > $location/all_objects.yaml

        echo "Backup discrete kubernetes templates by object type"
        for object in ${kubernetes_obj[@]}; do
            if [[ $debug > 0 ]]; then
                echo "exporting $object"
            fi
            ./oc3 get -o yaml $object > $location/$object.yaml
        done

        # for each environment let's compare the omnimanifest to the category manifest files.
        ./oc3-compare.py $location

    done
}

#=======================================
# MAIN

getParms "$@"
ocLogin
processExport $environments

# Do we really need this since we'll just terminate the container?
#ocLogout

#=======================================
exit 0
