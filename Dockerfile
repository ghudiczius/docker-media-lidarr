FROM mcr.microsoft.com/dotnet/runtime:9.0

ARG SOURCE_CHANNEL
ARG VERSION

# renovate: release=bookworm depName=curl
ENV CURL_VERSION=7.88.1-10+deb12u12
# renovate: release=bookworm depName=libchromaprint-tools
ENV LIBCHROMAPRINT_TOOLS_VERSION=1.5.1-2+b1
# renovate: release=bookworm depName=libsqlite3-0
ENV LIBSQLITE_VERSION=3.40.1-2+deb12u2

RUN apt-get update && \
    apt-get --assume-yes --quiet install \
        curl="${CURL_VERSION}" \
        libchromaprint-tools="${LIBCHROMAPRINT_TOOLS_VERSION}" \
        libsqlite3-0="${LIBSQLITE_VERSION}" && \
    groupadd --gid=1000 lidarr && \
    useradd --gid=1000 --home-dir=/opt/lidarr --no-create-home --shell /bin/bash --uid 1000 lidarr && \
    mkdir /config /downloads /music /opt/lidarr && \
    curl --location --output /tmp/lidarr.tar.gz "https://github.com/Lidarr/Lidarr/releases/download/v${VERSION}/Lidarr.${SOURCE_CHANNEL}.${VERSION}.linux-core-x64.tar.gz" && \
    tar xzf /tmp/lidarr.tar.gz --directory=/opt/lidarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /music /opt/lidarr && \
    rm /tmp/lidarr.tar.gz

USER 1000
VOLUME /config /downloads /music
WORKDIR /opt/lidarr

EXPOSE 8686
ENTRYPOINT ["/opt/lidarr/Lidarr"]
CMD ["-data=/config", "-nobrowser"]
