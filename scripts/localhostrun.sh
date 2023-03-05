#!/usr/bin/env bash
# Tunnel your running container to the outside world.
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/atrakic/github-flask-webhook/main/scripts/localhostrun.sh | bash -s

CONTAINER_NAME=${CONTAINER_NAME:?"Error, missing CONTAINER_NAME value of your running container"}
CONTAINER_PORT=${CONTAINER_PORT:?"Error, missing CONTAINER_PORT value of your running container"}
TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-''}  ## `man timeout`

set -e

cleanup() {
  docker stop "$CONTAINER_NAME" || true
  docker rm "$CONTAINER_NAME" || true
  echo 'Done!'
}

main() {
  local remote_port=80  
  local ssh_args=( -aT -R "${remote_port}":localhost:"$CONTAINER_PORT" ssh.localhost.run -- )

  if [ -z "$TIMEOUT_SECONDS" ]; then
    ssh "${ssh_args[@]}"
  else
    timeout "${TIMEOUT_SECONDS}" ssh "${ssh_args[@]}"
  fi
  trap cleanup EXIT
}

main "$@"
