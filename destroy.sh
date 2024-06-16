#! /bin/bash
./down.sh
echo "Destroying mullvad-proxy images..."

ENVFILE=.env
if [ -f "$ENVFILE" ]; then
    source $ENVFILE
fi
docker rmi "mullvad:${MULLVAD_VERSION:-latest}" mvpn-socks5 mvpn-proxy caligari/privoxy:latest
