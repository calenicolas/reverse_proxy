#!/bin/bash

. /usr/local/lib/reverse_proxy/generate_nginx_conf.sh
. /usr/local/lib/iptables_utils/allow_internal_forward_to_server.sh

function add_server_to_reverse_proxy() {
  local CONTAINER_NAME="$1"
  local SERVER_NAME="$2"
  local URI="$3"
  local CONTAINER_IP="$4"
  local PROTOCOL="$5"
  local PROXY_NETWORK="$6"
  local CONTAINER_NETWORK="$7"
  local SERVICE_PORT="$8"

  CONF_PATH=/etc/reverse-proxy/conf.d/"$CONTAINER_NAME/$SERVER_NAME.conf"

  generate_nginx_conf "$CONTAINER_NAME" "$SERVER_NAME" "$URI" "$CONTAINER_IP" > "$CONF_PATH"

  docker exec "$CONTAINER_NAME" nginx -s reload

  echo "$PROTOCOL" "$PROXY_NETWORK" "$CONTAINER_NETWORK" "$SERVICE_PORT" "$CONTAINER_IP"

  allow_internal_forward_to_server "$PROTOCOL" "$PROXY_NETWORK" "$CONTAINER_NETWORK" "$CONTAINER_IP" "$SERVICE_PORT"
}