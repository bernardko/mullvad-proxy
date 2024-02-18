#! /bin/bash
echo "Tearing down mullvad-proxy containers..."
echo "Getting account info and wireguard key..."
docker exec -it mvpn mullvad account get
docker exec -it mvpn mullvad tunnel get
docker compose down
echo "Remember to delete the above Wireguard keys from the account to free them up."
