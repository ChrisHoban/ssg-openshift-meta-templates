# Jenkins Pod Build Templates
 
Setup
  - Load template into Tools namespace, supply the prefix and version of dotnet 
  - It will create Build Config, Image Stream, and Jenkins ConfigMap
  - Run the Build Config manually to populate the image Stream
  - Jenkins will now be able to use node('name-of-your-image') as its slave pod