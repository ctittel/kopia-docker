FROM golang

RUN apt-get update &&\
    apt-get install git &&\
    apt-get clean

RUN cd / &&\
    git clone https://github.com/kopia/kopia.git &&\
    cd kopia &&\
    make install

RUN rm -r /kopia &&\
    go clean -modcache 

COPY script.bash /

ENV KOPIA_CACHE_DIRECTORY=/cache
ENV KOPIA_LOG_DIR=/logs
ENV KOPIA_CONFIG_PATH=/config/repository.config

WORKDIR /
ENTRYPOINT "/script.bash"

# Required env variables:
# ---
# KOPIA_PASSWORD - the password of the repository at /backup

# Optional env variables:
# ---
# KOPIA_SERVER_USERNAME - HTTP server username (Default = kopia)
# KOPIA_SERVER_PASSWORD - HTTP server password (Default = SERVER-PASSWORD)


# === Default kopia docker image ===
# ARG TARGETARCH

# # allow users to mount /app/config, /app/logs and /app/cache, /app/rclone respectively
# ENV KOPIA_CONFIG_PATH=/app/config/repository.config
# ENV KOPIA_LOG_DIR=/app/logs
# ENV KOPIA_CACHE_DIRECTORY=/app/cache

# # allow user to mount ~/.config/rclone to /app/rclone
# ENV RCLONE_CONFIG=/app/rclone/rclone.conf

# # this requires repository password to be passed via KOPIA_PASSWORD environment.
# ENV KOPIA_PERSIST_CREDENTIALS_ON_CONNECT=false
# ENV KOPIA_CHECK_FOR_UPDATES=false

# # this creates directories writable by the current user
# WORKDIR /app

# ENV PATH=/bin

# COPY bin-${TARGETARCH}/kopia .
# COPY bin-${TARGETARCH}/rclone /bin/rclone

# ENTRYPOINT ["/app/kopia"]
