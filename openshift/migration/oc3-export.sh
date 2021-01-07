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

getParms() {
    echo "### Obtain passed in paramaters ###"

    debug=0
    while getopts ":t:l:p:d:" option; do
        case ${option} in
            t) oc3_token=$OPTARG;;
            l) licenseplate=$OPTARG;;
            p) projectname=$OPTARG;;
            d) debug=$OPTARG;;
            *) usage;;
        esac
    done
    shift "$((OPTIND -1))"

    if [ -z $oc3_token ] || [ -z $licenseplate ] || [ -z $projectname ]; then
        usage
    fi

    if [[ $debug > 0 ]] ; then
        set -x  # turn off trace of commands
        echo "oc3_token is: $oc3_token"
        echo "licenseplate is: $licenseplate"
        echo "projectname is: $projectname"
        echo Remaining arguments: "$@"
    fi
}

ocLogin() {
    echo "### Logging into Openshift 3 ###"

    if ! command -v oc3 &> /dev/null; then
        echo "oc3 command doesn't exist.  Install oc and symlink oc3->oc. eg: 'ln -s /usr/local/bin/oc /usr/local/bin/oc3'"
        exit 1
    fi

    # TODO: Maybe we don't login via the script rather validate where we're logged in and request confirmation before export
    # TODO: Use kubeconfig file rather than doing the login via script?
    #echo "It's ok if there's an error here. We aren't using oc4 in this script. This logout is just in case you previously were logged into oc4"
    #oc4 logout
    echo ###### LOGIN TO OC3 ########
    # TODO: we're hard coding the OC path.  This is fine for now, but consider using a param or require user to log in beforehand.
    # TODO: perhaps require the user to log in first then us the "oc3 whoami -t" command combined with "oc3 whoami --show-server=true" to obtain the currently logged in token and url if bash session requires additional login.
    # NOTE: Having some challenges with validating if already logged in or not. 
    set +e
    oc3 whoami &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Already logged in."
    else
        echo "Log into openshift"
        oc3 login https://console.pathfinder.gov.bc.ca:8443 --token=${oc3_token}
    fi
    set -e
}

ocLogout() {
    echo "### Logging out of Openshift 3 ###"
    oc3 logout
}

processExport() {
    echo "### Export objects from Openshift 3 ###"

    environments=$1
    
    kubernetes_obj=()
    kubernetes_obj+=('buildconfigs')
    kubernetes_obj+=('imagestreams')
    kubernetes_obj+=('services')
    kubernetes_obj+=('cm')
    kubernetes_obj+=('secrets')
    #kubernetes_obj+=('egressnetworkpolicies')
    kubernetes_obj+=('statefulsets')
    kubernetes_obj+=('cronjobs')
    kubernetes_obj+=('serviceaccounts')
    kubernetes_obj+=('rolebindings')
    kubernetes_obj+=('endpoints')
    kubernetes_obj+=('deploymentconfigs')
    kubernetes_obj+=('replicationcontrollers')
    kubernetes_obj+=('builds')
    kubernetes_obj+=('imagestreamtags')
    kubernetes_obj+=('rolebindingrestrictions')
    kubernetes_obj+=('limitranges')
    kubernetes_obj+=('resourcequotas')
    kubernetes_obj+=('pvc')
    kubernetes_obj+=('templates')
    kubernetes_obj+=('hpa')
    kubernetes_obj+=('deployments')
    kubernetes_obj+=('replicasets')
    kubernetes_obj+=('poddisruptionbudget')
    kubernetes_obj+=('pods')

    for env in ${environments[@]}; do
        # TODO: we're making the directory before we know we have access to it.  Good idea to test access to the namespace before creating the directory
        mkdir -p openshift/manifests/$env
        pushd openshift/manifests/$env

        #Move into the correct namespace
        oc3 project $licenseplate-$env

        echo "Get the legacy main object backup (RAW) for $licenseplate-$env"
        oc3 get -o yaml all > all_objects.yaml

        echo "Backup discrete kubernetes templates by object type"
        for object in ${kubernetes_obj[@]}; do
            echo "exporting $object"
            oc3 get -o yaml $object > $object.yaml
        done

        popd
    done
}

#=======================================
# MAIN
getParms "$@"
ocLogin
environments=('tools' 'dev' 'test' 'prod')
processExport $environments
#ocLogout
#=======================================
exit 0