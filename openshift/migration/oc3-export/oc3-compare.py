#!/usr/bin/env python3

####
#
#   Used to compare the omnimanifest, that was exported from openshift 3, to the catagory manifests
#   to determine if something may have gone wrong.  This is not a definitive test as we're only
#   comparing one way.
#
#   ** CAUTION: This exports the oc secrets - DO NOT COMMIT SECRETS TO GIT!
#
####

import yaml
from pprint import pprint
import os
import sys


directory = sys.argv[1]

allObjFile = open(os.path.join(directory, "all_objects.yaml"))
with allObjFile as allObjFile:
    allObjDict = yaml.safe_load(allObjFile)

allObjItems = (allObjDict['items'])

omniManifestList = []
for allObjItem in allObjItems:
    allObjUid = (allObjItem['metadata']['uid'])
    allObjKind = (allObjItem['kind'])
    allObjName = (allObjItem['metadata']['name'])

    omniManifestList.append([allObjUid, allObjKind, allObjName])

groupedManifestList = []
for filename in os.listdir(directory):
    if filename.endswith(".yaml") and filename!="all_objects.yaml":
        workingfile = open(os.path.join(directory, filename))
        with workingfile as file:
            dataDict = yaml.safe_load(file)

        items = (dataDict['items'])
        for item in items:
            groupedObjUid = (item['metadata']['uid'])
            groupedObjKind = (item['kind'])
            groupedObjName = (item['metadata']['name'])

            groupedManifestList.append(groupedObjUid)


# for each item in the omniManifestList we need to see if we can find that item in the groupedManifestList
pprint("Searching through omnimanifest on project "+directory)
for itemList in omniManifestList:

    #pprint(itemList)
    if itemList[0] not in groupedManifestList:
        uid=itemList[0]
        kind=itemList[1]
        name=itemList[2]
        print("Didn't find "+uid+" in "+kind+" - "+name)

exit()
