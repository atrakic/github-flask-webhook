#!/usr/bin/env bash
# Put a locally running HTTP, HTTPS or TLS app on the internet

## Example usage:
# \curl -sSL https://raw.githubusercontent.com/atrakic/github-flask-webhook/main/scripts/localhostrun.sh | PORT=8080 bash -s

PORT=${PORT:?"Error, missing PORT value of your running container"}
TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-''}  ## `man timeout`

set -e

cleanup() {
  echo 'Done!'
}

main() {
  local remote_port=80  
  local ssh_args=( -aT -R "${remote_port}":localhost:"$PORT" ssh.localhost.run -- )

  if [ -z "$TIMEOUT_SECONDS" ]; then
    ssh "${ssh_args[@]}"
  else
    timeout "${TIMEOUT_SECONDS}" ssh "${ssh_args[@]}"
  fi
  trap cleanup EXIT
}

main "$@"
