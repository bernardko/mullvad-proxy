FROM ubuntu:20.04

LABEL maintainer="Bernard Ko <bernardko@gmail.com>"

RUN apt-get --yes update && \
    apt-get --yes install dbus curl && \
    curl -L -o mullvadvpn.deb https://github.com/mullvad/mullvadvpn-app/releases/download/2022.1/MullvadVPN-2022.1_amd64.deb && \
    apt-get --yes install ./mullvadvpn.deb && \
    rm -f mullvadvpn.deb && \
    apt-get --yes clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /conf
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]