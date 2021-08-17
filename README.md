# Credential Buildpack

version: 1.0.0

## Usage
This credential buildpack is a customised buildpack created for Cloud Foundry.
It is designed to supply credentials to a Cloud Foundry application and enables that application to authenticate with other services.

```
$ cf push <APP-NAME> -p <ARTIFACT> -b https://<BASE_URL>/credentials.git
```

## Example APP Manifest
Create an application manifest.xml within the route of your Cloud Foundry application.
 - reference the credentials buildpack url
 - reference the keystore through an evironment variable, where the keystore path is supplied as a jvm property
```
applications:
- name: <APP-NAME>
  disk_quota: 1024M
  memory: 1024M
  buildpacks:
    - https://<BASE_URL>/credentials.git
  env:
    JAVA_OPTS: '-Djavax.net.ssl.keyStore=CUSTOM_KEYSTORE'
```

