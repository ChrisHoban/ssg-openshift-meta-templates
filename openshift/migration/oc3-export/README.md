This procedure will download the openshift3 manifest files from the requested environment.  It will then compare each manifest category against the omni manifest to sanity check that nothing was missed.  Anything missed will require deeper investigation.

# Config

Start by copying the .env.template to .env and added the appropriate variables into the template.

TOKEN: abcdefg123456hijklmonp78990
- you can get the openshift token from the CLI.  Click on your profile on the top right and choose "Copy Login Command".  You'll need to manually prune the clipboard to extract the token.
- You can also obtain your token by first logging into CLI then issuing the command (which command will work depends on the version of OC CLI you're using)
`oc whoami --show-token`
`oc whoami --token`

LICENSEPLATE: zyxwvut
- This is the openshift namespace license plate. It is just the account prefix, not the environment (eg: no -dev or -prod)

ENVIRONMENT: dev,test,prod,tools
- List your desired environments here.

PROJECT: MyProject
- This is an arbitrary project name used for helping keep the folder structure organized.

# Run

To run the project simply run the docker-compose
`docker-compose up --build`

For convince the container just mounts the local folder rather than copying the files into the container. This has pros and cons.  Be aware that this will mean the manifest files will be exported to the local folder which may not be what you desire.  Be careful not to commit the manifest files to git.  Especially since the default setup exports the openshift secrets in both the secrets file as well as the omnimanifest.
# Output

The output will display discrepancies between the omnimanifest and the category files.