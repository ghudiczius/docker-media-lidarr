FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine3.22

ARG SOURCE_CHANNEL
ARG VERSION

# renovate: datasource=repology depName=alpine_3_22/curl versioning=loose
ENV CURL_VERSION=8.14.1-r1
# renovate: datasource=repology depName=alpine_3_22/sqlite-libs versioning=loose
ENV SQLITE_LIBS_VERSION=3.49.2-r1

RUN apk add --no-cache --update \
        curl="${CURL_VERSION}" \
        sqlite-libs="${SQLITE_LIBS_VERSION}" && \
    addgroup -g 1000 lidarr && \
    adduser -D -G lidarr -h /opt/lidarr -H -s /bin/sh -u 1000 lidarr && \
    mkdir /config /downloads /music /opt/lidarr && \
    curl --location --output /tmp/lidarr.tar.gz "https://github.com/Lidarr/Lidarr/releases/download/v${VERSION}/Lidarr.${SOURCE_CHANNEL}.${VERSION}.linux-musl-core-x64.tar.gz" && \
    tar xzf /tmp/lidarr.tar.gz --directory=/opt/lidarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /music /opt/lidarr && \
    rm /tmp/lidarr.tar.gz

USER 1000
VOLUME /config /downloads /music
WORKDIR /opt/lidarr

EXPOSE 8686
ENTRYPOINT ["/opt/lidarr/Lidarr"]
CMD ["-data=/config", "-nobrowser"]
