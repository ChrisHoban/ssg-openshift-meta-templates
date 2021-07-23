#!/usr/bin/env python3

####
#
#   Used to sanitize the exported kubernetes template or object to strip out undesired elements
#
####

import yaml
import os
import sys


workingfolder = sys.argv[1]
workingfile = sys.argv[2]
location = workingfolder+"/"+workingfile

with open(location, 'r') as filestream:
    try:
        dataDict = yaml.safe_load(filestream)
    except yaml.YAMLError as exc:
        print(exc)

# Search through the manifest and flag the objects that need to be removed
# Once all the offending objects have been identified delete them.
# TODO: Build in a feature to do wildcard searches for these strings. (Specifically around "jenkins*")
offenders = ["maven","nexus","sonarqube", "jenkins-2-rhel7"]
i=0
itemsToDelete = []

for items in dataDict["objects"]:
    try:
        object_name = items["metadata"]["name"]
        if object_name in offenders:
            print("Adding to prune list :", object_name)
            itemsToDelete.append(i)
        i += 1
    except:
        print("no metadata-name to sanitize")

for delitem in sorted(itemsToDelete, reverse=True):
    print("Deleting Offending Objects")
    del dataDict["objects"][delitem]

# Delete creationTimestamps
try:
    del dataDict["metadata"]["creationTimestamp"]
except:
    print("no creationTimestamp to delete")

# Delete creationTimestamps and status from objects
for items in dataDict["objects"]:
    try:
        del items["metadata"]["creationTimestamp"]
    except:
        print("no object creationTimestamp")

    try:
        del items["status"]
    except:
        print("no status to delete")

# save the sanitized file:
savefolder = workingfolder+"/sanitized"
savelocation = savefolder+"/"+workingfile

if not os.path.exists(savefolder):
    os.mkdir(savefolder)

print("Writing to file: "+savelocation)
with open(savelocation, 'w') as filesave:
    documents = yaml.dump(dataDict, filesave)

exit()
