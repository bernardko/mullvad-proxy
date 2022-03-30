#! /bin/bash
echo "Tearing down mullvad-proxy containers..."
echo "Getting account info and wireguard key..."
docker exec -it mvpn mullvad account get
docker exec -it mvpn mullvad tunnel wireguard key check
docker-compose down
docker stop mvpn > /dev/null
docker rm mvpn > /dev/null
echo "Delete the above wireguard key at https://mullvad.net/en/account/#/ports"