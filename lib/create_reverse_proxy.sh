#!/bin/bash

. /usr/local/lib/docker_utils/docker_run_with_volume.sh
. /usr/local/lib/iptables_utils/allow_forward_to_server_from_any.sh

function create_reverse_proxy() {
  local CONTAINER_NAME="$1"
  local SERVICE_PORT="$2"
  local INTERNAL_NETWORK="$3"
  local IMAGE_NAME="$4"
  local PROTOCOL="$5"
  local PUBLIC_INTERFACE="$6"
  local PUBLIC_PORT="$7"

  CONF_PATH=/etc/reverse-proxy/conf.d/"$CONTAINER_NAME"
  mkdir "$CONF_PATH"

  CONTAINER_IP=$(docker_run_with_volume "$CONTAINER_NAME" "$SERVICE_PORT" "$INTERNAL_NETWORK" "$IMAGE_NAME" "$CONF_PATH" "/etc/nginx/conf.d")

  allow_forward_to_server_from_any "$PROTOCOL" "$PUBLIC_INTERFACE" "$INTERNAL_NETWORK" "$PUBLIC_PORT" "$CONTAINER_IP" "$SERVICE_PORT"
}