Repo auto-updating container
---------------------------

Image: [repo-autoupdate](https://registry.legato/repo-autoupdate/)

This image:
 - takes a `MANIFEST_URL` and `MANIFEST`, that it clones and expose as a volume (`/repo`)
 - polls from the git remotes periodically

Arguments:
 - `MANIFEST_URL`: provided as this to repo init url
 - `MANIFEST`: provided as this to repo init manifest
 - `REPO_GROUPS`: provided as this to repo init groups (default: default,letp)
 - `POLLING_FREQ`: polling frequency as given to cron, something like "*/5 * * * *", default to 5 minutes
 - `VOLUME_PATH`: if you're not happy with the default volume `/repo`
 - `ONE_SHOT`: run only ones and do not trigger cron

For instance you can deploy this as a systemd unit to serve an always up-to-date repository to other services.

Sample usages:

 - Example repo:
```
docker run \
            --rm \
            --name legato-qa \
            -e MANIFEST_URL=git://gerrit-legato/manifest \
            -e MANIFEST=legato-qa/branches/master.xml \
            repo-autoupdate
```

 - Expose repo as another name:
```
docker run \
            --rm \
            --name legato-qa \
            -e MANIFEST_URL=git://gerrit-legato/manifest \
            -e MANIFEST=legato-qa/branches/master.xml \
            -e VOLUME_PATH=/legato-qa \
            -v /legato-qa \
            repo-autoupdate
```
