# Use the official image as a parent image
FROM ubuntu:noble-20240605

ARG TARGETARCH

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get upgrade --yes && apt-get autoremove --yes && \
    apt-get install --no-install-recommends --yes apt-transport-https=* ca-certificates=* dumb-init=* jq=* gettext-base curl wget vim postgresql-client && \
    apt-get autoremove && apt-get clean -y && rm -rf /var/lib/apt/lists/* ~/.cache /tmp/* && rm -f /var/cache/apt/*.bin && \
    depName="$(awk -F= '/^ID=/{gsub(/"/, ""); print $2}' /etc/os-release)_$(awk -F= '/^VERSION_ID=/{gsub(/"/, ""); gsub(/\./,"_"); print$2}' /etc/os-release)" && \
    dpkg-query -f 'datasource=repology depName='"${depName}"'/${binary:Package} versioning=loose version=${Version}\n' -W > /tmp/apt-list-base-${TARGETARCH}

RUN groupadd --system --gid 10000 doe && \
    useradd \
        --system \
        --create-home \
        --home-dir /home/doe \
        --shell /bin/bash \
        --uid 10000 \
        --gid 10000 \
        doe

USER doe
