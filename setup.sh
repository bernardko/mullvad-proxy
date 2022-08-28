#! /bin/bash
echo "Setting up mullvad-proxy..."
ENVFILE=.env
if [ -f "$ENVFILE" ]; then
    echo "Found $ENVFILE file..."
    source $ENVFILE
fi

ACCOUNT=${1:-$ACCOUNT_NUMBER}

if [ -z "$ACCOUNT" ]; then
    echo "Please enter Mullvad account number:"
    read ACCOUNT
fi

docker build -t mullvad:latest mullvad/.
docker run --privileged --cgroupns=host --cap-add=NET_ADMIN --cap-add=SYS_MODULE --restart unless-stopped --name mvpn -d  -p 61000:1080 -p 61001:8118 mullvad:latest

if [ -f "$ENVFILE" ]; then
    docker compose --env-file $ENVFILE up -d
else 
    docker compose up -d
fi

if [ -n "$ACCOUNT" ]; then
    echo "Setting Mullvad Account Number: $ACCOUNT"
    docker exec -it mvpn mullvad status
    docker exec -it mvpn mullvad account get
    docker exec -it mvpn mullvad account set $ACCOUNT
    docker exec -it mvpn mullvad relay set tunnel-protocol wireguard
    if [ -n "$DEFAULT_COUNTRY" ]; then
        echo "Setting Relay Location: $DEFAULT_COUNTRY"
        docker exec -it mvpn mullvad relay set location $DEFAULT_COUNTRY
    fi
    docker exec -it mvpn mullvad always-require-vpn set on
    docker exec -it mvpn mullvad lan set allow
    docker exec -it mvpn mullvad auto-connect set on
    echo "Waiting for Mullvad API Connection..." && sleep 7
    docker exec -it mvpn mullvad tunnel wireguard key regenerate
    docker exec -it mvpn mullvad connect
    echo "Waiting for Connection Status..." && sleep 7
    docker exec -it mvpn mullvad status
fi
