FROM ubuntu:20.04

LABEL maintainer="Bernard Ko <bernardko@gmail.com>"

RUN apt-get --yes update && \
    apt-get --yes install dbus curl && \
    curl -L -o mullvadvpn.deb https://mullvad.net/download/app/deb/latest && \
    apt-get --yes install ./mullvadvpn.deb; exit 0

RUN rm -f mullvadvpn.deb && \
    apt-get --yes clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /conf
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]