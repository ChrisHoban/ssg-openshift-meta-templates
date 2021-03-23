#!/bin/bash

# Hide trace of commands
set +x
set -e

####
#
#   Used to extract openshift 3 (or openshift 4) objects and saves them as files.
#   It initlally downloads each object as seperate files
#   then validates by downloading the entire namespace
#   and compares the outputes to ensure they're are the same
#
#   ** CAUTION: This exports the oc secrets - DO NOT COMMIT SECRETS TO GIT!
#
####

PROGNAME=$0

function usage() {
    cat << EOF >&2
Usage: $PROGNAME [-t] [-l] [-p]

-t <loginhash> : (required) obtain the token from the opensift account found here: "(?) Help -> About -> Command Line Tools"
-l <prefix>    : (required) this is the prefix or license plate of the requested namespace.  Can be obtained from command: "oc get projects"
-p <project>   : (required) arbitrary project name used for outputing labeling the exported folder/files
-d <boolean>   : (optional) turn on debug by passing in an integer 1-9 (default 0 = off)
-s <boolean>   : (optional) have the descrete kubernetes manifest files sanitized by stripping out unnecesary entries (default 0 = off)
-c <boolean>   : (optional) if 1 then overwrite then blindly overwrite the files. Will overwrite omnimanifest regardless of setting. Default is to preserve the files (default 0 = off)
EOF
    exit 1
}

function checkEnv() {
    if [[ -z $OC_TOKEN ]] || [[ -z $OC_LICENSEPLATE ]] || [[ -z $PROJECT ]] || [[ -z $OC_ENVIRONMENT ]]; then
        usage
    else
        oc_token="${OC_TOKEN}"
        licenseplate="${OC_LICENSEPLATE}"
        projectname="${PROJECT}"
        debug="${DEBUG}"
        sanitize="${SANITIZE}"
        clobber="${CLOBBER}"
        oc_command="${OC_VERSION}"
        template="${TEMPLATE}"

        # This explodes the ENVIRONMENT string (passed in as an environment variable) into an array
        environments=(${OC_ENVIRONMENT//,/ })
    fi
}

function getParms() {
    debug=0
    clobber=0
    sanitize=0
    echo "### Obtain passed in paramaters ###"
    # There's an assumption that if one paramater is passed in that all are expected and no environment variables will be considered.
    if [[ -z $1 ]]; then
        checkEnv
    else
        while getopts ":t:l:p:d:e:s:c:" option; do
            case ${option} in
                t) oc_token=$OPTARG;;
                l) licenseplate=$OPTARG;;
                p) projectname=$OPTARG;;
                d) debug=$OPTARG;;
                e) environments=$OPTARG;;
                s) sanitize=$OPTARG;;
                c) clobber=$OPTARG;;
                *) usage;;
            esac
        done
        shift "$((OPTIND -1))"
    fi

    if [[ $debug > 0 ]]; then
        set -x  # turn off trace of commands
        echo "oc_token is: $oc_token"
        echo "licenseplate is: $licenseplate"
        echo "projectname is: $projectname"
        echo Remaining arguments: "$@"
    fi
}

ocLogin() {
    if [[ ! -f ./oc3 ]]; then
        # download the OpenShift CLI for openshift3 - since this is now a mounted volume, it'll only download to the workstation the first time.
        wget https://nttdata-canada.s3.ca-central-1.amazonaws.com/oc3
    fi

    if [[ ! -f ./oc4 ]]; then
        # download the OpenShift CLI for openshift4 - since this is now a mounted volume, it'll only download to the workstation the first time.
        wget https://nttdata-canada.s3.ca-central-1.amazonaws.com/oc4
        chmod +rx ./oc4
    fi

    if [[ $OC_VERSION == oc3 ]]; then
        echo ###### LOGIN TO OC3 ########
        ./oc3 login https://console.pathfinder.gov.bc.ca:8443 --token=${oc_token}
    elif [[ $OC_VERSION == oc4 ]]; then
        echo ###### LOGIN TO OC4 ########
        ./oc4 login https://api.silver.devops.gov.bc.ca:6443 --token=${oc_token}
    else
        echo "OC version is invalid. Update your environment."
    fi
}

function processExport() {
    echo "### Export objects from Openshift 3 ###"

    environments=$1

    kubernetes_obj=()
    kubernetes_obj+=('builds')
    kubernetes_obj+=('buildconfigs')
    kubernetes_obj+=('cm')
    kubernetes_obj+=('cronjobs')
    kubernetes_obj+=('deploymentconfigs')
    kubernetes_obj+=('deployments')
    kubernetes_obj+=('endpoints')
    kubernetes_obj+=('hpa')
    kubernetes_obj+=('imagestreams')
    kubernetes_obj+=('limitranges')
    kubernetes_obj+=('poddisruptionbudget')
    kubernetes_obj+=('pvc')
    kubernetes_obj+=('replicasets')
    kubernetes_obj+=('replicationcontrollers')
    kubernetes_obj+=('routes')
    kubernetes_obj+=('rolebindings')
    kubernetes_obj+=('secrets')

    # Yes, we're exporting secrets.  This is being exported by the omnimanifest so the cat is already out of the bag.
    # *** DO NOT COMMIT THIS FILE TO GIT!!! ***
    ##kubernetes_obj+=('secrets')
    ##kubernetes_obj+=('serviceaccounts')
    # kubernetes_obj+=('services')
    # kubernetes_obj+=('statefulsets')
    # kubernetes_obj+=('templates')
    ##kubernetes_obj+=('egressnetworkpolicies')
    ##kubernetes_obj+=('imagestreamtags')
    ##kubernetes_obj+=('pods')
    ##kubernetes_obj+=('resourcequotas')
    ##kubernetes_obj+=('rolebindingrestrictions')
    ##kubernetes_obj+=('rolebindings')


    for env in ${environments[@]}; do
        # TODO: we're making the directory before we know we have access to it.  Good idea to test access to the namespace before creating the directory
        location=exports/$projectname-$licenseplate/$env
        mkdir -p $location

        #Move into the correct namespace
        ./$oc_command project $licenseplate-$env

        echo "Get the omnimanifest object (RAW) for $licenseplate-$env"

        # Yes, this will export secrets. I don't know a way around this yet.
        # *** DO NOT COMMIT THIS FILE TO GIT!!! ***
        # export feature has been depticated, but still exists. The bash error handling need to bypass the oc3 warning
        # set +e
        # ./oc3 export $object --as-template=all > $location/all_objects.yaml
        # set -e
        # an alternate method is to use get but it's not sanitized...so will need to run the sanitize procedure if you use this method.
        # ./oc3 get -o yaml all > $location/all_objects.yaml

        echo "Backup discrete kubernetes templates by object type"
        for object in ${kubernetes_obj[@]}; do
            if [[ $debug > 0 ]]; then
                echo "exporting $object"
            fi

            if [[ ! -f $location/$object.yaml ]]; then
                # create the object if it's not already there
                set +e
                if [[ $template == 1 ]]; then
                    # export feature has been depricated, but still exists. The bash error handling need to bypass the oc3 warning
                    ./$oc_command export $object --as-template=$object > $location/$object.yaml
                else
                    ./$oc_command get -o yaml $object > $location/$object.yaml
                fi
                set -e
                # ./oc3 get -o yaml $object > $location/$object.yaml
            else
                # The file does exist...what should we do?
                if [[ $clobber > 0 ]]; then
                    set +e
                    if [[ $template == 1 ]]; then
                        # export feature has been depricated, but still exists. The bash error handling need to bypass the oc3 warning
                        ./$oc_command export $object --as-template=$object > $location/$object.yaml
                    else
                        ./$oc_command get -o yaml $object > $location/$object.yaml
                    fi
                    set -e
                fi
            fi

            # if we've been asked to sanitize, now is a good time to do it.
            if [[ $sanitize > 0 ]]; then
                if [[ -s $location/$object.yaml ]] ; then
                    #sanitize file if it's greater than 0 in size
                    echo "### Run Sanitize on $location/$object.yaml"
                    ./oc-sanitize.py $location $object.yaml
                fi
            fi

        done

        #for each environment let's compare the omnimanifest to the category manifest files.
        #echo "### Run Compare"
        #./oc3-compare.py $location $clobber

    done
}

function sanitize() {
    # This removes all unnecessary elements from the manifest files and deletes the empty ones.
    # Generally we like to do this for the migration or for storing the manifest files in git
    dirfile=$1
    echo "Sanitize $dirfile"

    # add a sanitize folder in front of the filename that's passed in. This keeps things organized.
    # use bash magic to extract the file name and folder name and inject the sanitize folder
    sanitized_directory="${dirfile%/*}/sanitized"
    if [ ! -d $sanitized_directory ]; then
        mkdir $sanitized_directory
    fi

    sanitized_location="$sanitized_directory/${dirfile##*/}"

    # strip out all the elements that aren't needed to be stored in the manifest (ie: cluster specific elements)
    sed "/creationTimestamp/d; \
        /resourceVersion/d; \
        /selfLink/d;  \
        /uid/d; \
        /namespace/d; \
        /status/d; \
        /openshift\.io\/generated\-by/d; \
        /annotations/d;" \
        $dirfile > $sanitized_location

        # potential other keys to prune out

    # delete known useless multiline patterns. Note: this may result in an empty file.
    sed -z -i 's/apiVersion: v1\nitems: \[\]\nkind: List\nmetadata:\n//g' $sanitized_location #> $sanitized_location

    # now delete all the empty files that are left orphaned
    find $sanitized_directory -size 0 -print -delete

}

#=======================================
# MAIN

getParms "$@"
ocLogin
processExport $environments

#=======================================
exit 0
