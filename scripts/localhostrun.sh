#!/usr/bin/env bash

# Tunnel your containers to outside ;)

DOCKER_CONTAINER=${DOCKER_CONTAINER:?"You need to configure the DOCKER_CONTAINER environment variable, eg. 'containous/whoami' !"}
DOCKER_PORT=${DOCKER_PORT:-5000}
TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-''}  ## man timeout

readonly name=localhostrun
readonly remote_port=80
readonly localhost_port=8080

set -e

del_stopped(){
  local state
  state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)
  if [[ "$state" == "true" ]]; then
    cleanup
  fi
}

docker_run(){
  del_stopped || true

  docker run -d \
    -p "$localhost_port":"$DOCKER_PORT" \
    -e "API_SECRET=s3cRet" \
    --name "$name" \
  "$DOCKER_CONTAINER"
  #curl -f http://localhost:"$localhost_port" &>/dev/null
}

cleanup() {
  docker stop "$name" || true
  docker rm "$name" || true
  echo 'Done!'
}

main() {
  local ssh_args=( -aT -R "${remote_port}":localhost:"$localhost_port" ssh.localhost.run -- )
  docker_run

  if [ -z "$TIMEOUT_SECONDS" ]; then
    ssh "${ssh_args[@]}"
  else
    timeout "${TIMEOUT_SECONDS}" ssh "${ssh_args[@]}"
  fi
  trap cleanup EXIT
}

main "$@"
