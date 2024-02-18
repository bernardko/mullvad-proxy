FROM ubuntu:22.04

LABEL maintainer="Ivan Miric"

# Install Mullvad VPN binaries only. We don't install the Debian package
# directly since it depends on systemd, which is difficult to setup in
# containers because it requires to be running as PID 1.
RUN DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get install -y curl dbus && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/* && \
    curl -fsSL -o mullvadvpn.deb https://mullvad.net/download/app/deb/latest && \
    dpkg-deb -R mullvadvpn.deb /tmp/pkg && \
    mv /tmp/pkg/usr/bin/* /usr/local/bin/ && \
    rm -rf mullvadvpn.deb /tmp/pkg

VOLUME /conf
ENV MULLVAD_SETTINGS_DIR=/conf

ENTRYPOINT ["/usr/local/bin/mullvad-daemon"]
CMD ["-v"]
