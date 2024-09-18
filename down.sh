#! /bin/bash
echo "Tearing down mullvad-proxy containers..."
echo "Getting account info and wireguard key..."

# Get all account & devices
account="$(docker exec -it mvpn mullvad account get)"
devices="$(docker exec --tty mvpn mullvad account list-devices | tail -n +2)"

echo $account
docker exec -it mvpn mullvad tunnel get

# loop till we get this device
while IFS= read -r device; do
    # echo "device $device"
    found="$(echo "$account" | grep "$device")"
    if [ -n "$found" ]; then
        deviceStr="$(echo "${device//[$'\t\r\n']/}")"
        echo "Removing device '$deviceStr'"
        # remove device
        docker exec --tty mvpn mullvad account revoke-device "$deviceStr"

    fi
done <<<"$devices"

docker compose down --volumes --remove-orphans