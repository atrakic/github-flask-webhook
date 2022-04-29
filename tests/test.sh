#!/usr/bin/env bash

# https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#ping

set -ex

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
secret="f2b0299c2550eb917644f71654b239192aba48332194cf2da768fd54d83b77d9"

curl -v -X POST \
  -H 'Content-Type: application/json'  \
  -H 'User-Agent: GitHub-Hookshot/c4711b9' \
  -H 'X-GitHub-Delivery: 32f34196-c724-11ec-86d9-5aea6ccf2126' \
  -H 'X-GitHub-Event: push' \
  -H 'X-GitHub-Hook-ID: 355618468' \
  -H 'X-GitHub-Hook-Installation-Target-ID: 173471214' \
  -H 'X-GitHub-Hook-Installation-Target-Type: repository' \
  -H 'X-Hub-Signature: sha1=785ad87f2fba1ab52c3bd80989ffd00bf094ff42' \
  -H 'X-Hub-Signature-256: sha256='"$secret" \
  -d @"$scriptdir/data.json" \
  http://0.0.0.0:5000/webhook
