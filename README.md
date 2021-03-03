# unbound docker image

## Features
- Alpine 3.12.4 based
- apks added: unbound & drill
- only using itself as dns resolver
- bootstrap process for downloading the current root.hints form internic and verifying the anchor at first start
- unbound config for recusive resolving

## Folders
- /app/data:   hints & anchor files
- /app/config:   bootstrap & unbound config files
- /app/config/conf.d:   optional unbound config which are automatically included 

## Environment
- HEALTHCHECK_URL:   url which is used during docker healthchecks (Default: internic.net)
