#! /bin/bash
./down.sh
echo "Destroying mullvad-proxy images..."
docker rmi mullvad:latest mvpn-http mvpn-socks5 mvpn-proxy caligari/privoxy:latest