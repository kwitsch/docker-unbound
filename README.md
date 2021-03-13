# unbound docker image

## Features
- Alpine 3.12.4 based
- apks added: unbound & drill
- only using itself as dns resolver
- unbound config for recusive resolving
- monthly autobuild to ensure up to date root.hints

## Folders
- /app/data:   hints & anchor files
- /app/config:   unbound config files
- /app/config/conf.d:   optional unbound config which are automatically included 

## Environment
- HEALTHCHECK_URL:   url which is used during docker healthchecks (Default: internic.net)
