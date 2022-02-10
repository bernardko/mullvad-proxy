#! /bin/bash
echo "Getting account info and wireguard key..."
docker exec -it mvpn mullvad account get
docker exec -it mvpn mullvad tunnel wireguard key check
docker-compose down
echo "Remember to delete the above wireguard keys from the account to free them up."