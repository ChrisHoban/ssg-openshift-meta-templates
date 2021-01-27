#!/usr/bin/env python3

####
#   NOT CURRENTLY USED
#   - this method changes the yaml content formating which is less readable and not optimal
#     so I've obsoleted this script in favour of using sed in bash.
#     keeing this around for reference for now.
#   Used to compare the omnimanifest, that was exported from openshift 3, to the catagory manifests
#   to determine if something may have gone wrong.  This is not a definitive test as we're only
#   comparing one way.
#
#   ** CAUTION: This exports the oc secrets - DO NOT COMMIT SECRETS TO GIT!
#
####

import yaml
from nested_lookup import get_occurrence_of_key, nested_delete, nested_lookup
from pprint import pprint
import os
import sys


directory = sys.argv[1]
location=directory+"/sanitized/"
if not os.path.exists(location):
    os.mkdir(location)

groupedManifestList = []
for filename in os.listdir(directory):
    if filename!="all_objects.yaml" and filename!="sanitized":
        workingfile = open(os.path.join(directory, filename))
        with workingfile as file:
            dataDict = yaml.safe_load(file)

        print("Sanitizing "+filename)

        dataDictionatry = {key: value for key, value in dataDict.items() if value is not None}

        #print(dataDictionatry)

        # results = nested_delete(dataDict, "resourceVersion", in_place=True)
        # results = nested_delete(dataDict, "selfLink", in_place=True)
        # results = nested_delete(dataDict, "creationTimestamp", in_place=True)
        # results = nested_delete(dataDict, "uid", in_place=True)
        # results = nested_delete(dataDict, "namespace", in_place=True)

        # results = nested_delete(dataDict, "resourceVersion", in_place=True)
        # results = nested_delete(dataDict, "selfLink", in_place=True)
        # results = nested_delete(dataDict, "namespace", in_place=True)
        
        # results = nested_delete(dataDict, "status", in_place=True)
        # results = nested_delete(dataDict, "items", in_place=True)

        #results = nested_delete(dataDict, "annotations", in_place=True)


        #result = nested_lookup('resourceVersion', dataDict)

        #print(dataDict)
        # print(type(result))


        print("Writing to file: "+filename)
        with open(location+"/"+filename, 'w') as file:
            documents = yaml.dump(results, file)

exit()
