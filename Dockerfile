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
