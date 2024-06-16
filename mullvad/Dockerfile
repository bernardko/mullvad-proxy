FROM ubuntu:24.04

LABEL maintainer="Bernard Ko"

# Credit to Ivan Miric for the following from imiric/mullvad-proxy

ARG VERSION=2024.3

# Install Mullvad VPN binaries only. We don't install the Debian package
# directly since it depends on systemd, which is difficult to setup in
# containers because it requires to be running as PID 1.
RUN DEBIAN_FRONTEND=noninteractive; apt-get --yes update && \
    apt-get --yes install ca-certificates dbus curl dnsutils && \
    curl -fsSL -o mullvadvpn.deb "https://mullvad.net/media/app/MullvadVPN-${VERSION}_$(dpkg --print-architecture).deb" && \
    dpkg-deb -R mullvadvpn.deb /tmp/pkg && \
    mv /tmp/pkg/usr/bin/* /usr/local/bin/

RUN rm -f mullvadvpn.deb && \
    rm -rf /tmp/pkg && \
    apt-get --yes clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /conf
ENV MULLVAD_SETTINGS_DIR=/conf

ENTRYPOINT ["/usr/local/bin/mullvad-daemon"]
CMD ["-v"]
