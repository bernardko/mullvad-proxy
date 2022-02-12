# Mullvad VPN HTTP and SOCKS5 Proxy using Docker

This docker compose setup runs the [Mullvad VPN app](https://mullvad.net/en/download/linux/) inside a docker container and exposes an HTTP proxy using privoxy (port 8118) and SOCKS5 proxy using nginx (port 1080). The Mullvad CLI can still be used to control the application.

## Why

Mullvad VPN app works well and has easy to use CLI functionality for switching between their worldwide servers. However, when it is enabled, it will route all of your internet traffic through it and sometimes that is not ideal. If you want have VPN access for individual applications (e.g. Firefox but not Chrome) without routing all your internet traffic through it, then this setup will work with any applications that can use a HTTP or a SOCKS5 proxy server.

## What's New

**HTTP and SOCKS5 proxy ports can now be accessed over IP address on your network.**

Previously, the http and socks5 proxy only worked when applications using them were also on the host machine. This was great if you were just using it on your local system (which I was in my case). However, if you wanted to host it on server and have your network access it, then it wouldn't work due to possibly the Mullvad app security filtering out IP addresses that was outside of the docker network IP range on your host machine.

To get around this problem, we serve the ports over the network via an nginx reverse proxy just like how web applications are served. A new container has been added using the docker host network which proxies the exposed ports on the mullvad container. The mullvad container ports are now exposed as ports 61000-61001 to try to avoid collisions with other applications and nginx now will proxy these ports on SOCKS5 (port 1080) and HTTP (port 8118) making them accessible to the network. 

## Requirements and Usage

This setup has been tested on Ubuntu Linux and should work with all Debian-based Linux OSes. You will need the following to use this repository:
- git
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- An active [Mullvad VPN](https://mullvad.net/en/) Account Number

Once you have an active account, go to the [Mullvad Manage ports and WireGuard keys page](https://mullvad.net/en/account/#/ports) and make sure you have at least 1 wireguard key available to allow the Mullvad VPN container to connect. Each account number has a total of 5 wireguard keys.

Make sure ports 8118 and 1080 are available. If you need to bind the proxy servers to different ports, you can create a `.env` in the same path as the docker-compose.yml file with the following to change the ports:

```bash
HTTP_PORT=8118
SOCKS5_PORT=1080
```

Once the above is setup, run the following to get the proxy servers up and running:

```bash
git clone https://github.com/bernardko/mullvad-proxy.git
cd mullvad-proxy
./setup.sh <Mullvad Account Number>
```

The setup.sh script runs `docker-compose up -d` to setup Mullvad VPN and proxy docker  containers with container networking and then runs several Mullvad VPN CLI commands to setup the app with the account number and connects to the VPN. The containers are configured to auto restart and will be available whenever your machine starts as long as docker is running.

The Mullvad account number can also be set in the .env file.
```bash
ACCOUNT_NUMBER=<Mullvad Account Number>
HTTP_PORT=8118
SOCKS5_PORT=1080
```
With this set, you can just run `./setup.sh` to get the containers up and running.

To teardown the containers, use the following:

```bash
./destroy.sh
```

This script first runs `mullvad account get` and `mullvad tunnel wireguard key check` to output the account and wireguard key that is used in the docker container. Finally it will run `docker-compose down` to teardown the container processes. This allows you to conveniently delete the unused key from the [Manage ports and WireGuard keys page](https://mullvad.net/en/account/#/ports) (without having to guess which key it is) so that it is not locked up.


## Use Mullvad CLI

All [Mullvad CLI](https://mullvad.net/en/help/how-use-mullvad-cli/) commands can be used to control the Mullvad app.

For example, to change VPN location, use the following Mullvad CLI command through docker exec:

```bash
docker exec -it mvpn mullvad relay set location us
```