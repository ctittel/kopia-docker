# kopia-docker

An automated Docker-setup for kopia.

The Dockerfile downloads kopia from its repository, compiles and installs it.

The entrypoint:

1. Checks if there is a kopia repository at `/backup`; if not it will be initialized (with the password from the `$KOPIA_PASSWORD`)
2. Connects the repository at `/backup` (using the password from `$KOPIA_PASSWORD`)
3. Start the kopia HTML server on port `51515`

After this, you can visit `http://<hostname>:51515` and set up your backups (Remember where you mount the files you want to back up in the container; in the docker-compose example below they are mounted to `/files` in the container, so you would need to create backups for e.g. `/files/important-stuff`).

Each time the docker container is recreated / restarted, a new user is created for the snapshots (e.g. `root@db0ea1ccd4a0`).
But because of Kopia's deduplication this shouldn't make a difference space-wise and with the repositories main password (in `KOPIA_PASSWORD`), you can mount these other "users" repositories too.


## docker-compose

```
version: "3.3"
services:
  kopia:
    build: https://github.com/ctittel/kopia-docker.git#main
    container_name: kopia
    environment:
      - KOPIA_PASSWORD # important: the password for the repository at /backup
      - KOPIA_SERVER_USERNAME # optional: the username for the HTML UI; Default: kopia
      - KOPIA_SERVER_PASSWORD # optional: the password for the HTML UI; Default: unknown to me
      - PUID=1000 # optional
      - PGID=1000 # optional
      - TZ=Europe/Berlin # optional
    volumes:
      - /path/to/logs:/logs # optional: where kopia should put its log files
      - /path/to/config:/config # optional: where kopia should store its config file
      - /path/to/cache:/cache # optional: where kopia puts its cache
      - /path/to/backup:/backup # important: locatoin where the kopia repository is / will be created
      - /path/to/files:/files # important: the files to be backed up
    ports:
      - 51515:51515 # port for the web UI; you can of course map it to another port
    restart: unless-stopped
```
