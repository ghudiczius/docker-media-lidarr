FROM mono:6.12.0.107

ARG VERSION

RUN apt-get update && \
    apt-get --assume-yes install libchromaprint-tools && \
    groupadd --gid=1000 lidarr && \
    useradd --gid=1000 --home-dir=/opt/lidarr --no-create-home --shell /bin/bash --uid 1000 lidarr && \
    mkdir /config /downloads /music /opt/lidarr && \
    curl --location --output /tmp/lidarr.tar.gz "https://github.com/Lidarr/Lidarr/releases/download/v${VERSION}/Lidarr.master.${VERSION}.linux-core-x64.tar.gz" && \
    tar xzf /tmp/lidarr.tar.gz --directory=/opt/lidarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /music /opt/lidarr && \
    rm /tmp/lidarr.tar.gz

USER 1000
VOLUME /config /downloads /music
WORKDIR /opt/lidarr

EXPOSE 8686
ENTRYPOINT ["mono"]
CMD ["/opt/lidarr/Lidarr", "-data=/config", "-nobrowser"]
