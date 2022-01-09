#! /bin/bash
docker-compose up -d
docker exec -it mvpn mullvad status
docker exec -it mvpn mullvad account get
docker exec -it mvpn mullvad account set $1
docker exec -it mvpn mullvad relay set tunnel-protocol wireguard
docker exec -it mvpn mullvad always-require-vpn set on
docker exec -it mvpn mullvad lan set allow
docker exec -it mvpn mullvad auto-connect set on
echo "Waiting for Mullvad API Connection..." && sleep 7
docker exec -it mvpn mullvad tunnel wireguard key regenerate
docker exec -it mvpn mullvad connect
echo "Waiting for Connection Status..." && sleep 7
docker exec -it mvpn mullvad status