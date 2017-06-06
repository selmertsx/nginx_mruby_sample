#!/usr/bin/env bash

# When dehydrated is run locally, it will call this hook script when
# various things need to be setup (for example, setting up the challenge token
# or deploying the certs). In turn, this script will call our internal hook
# HTTP API server which can then set the needed data on the current storage
# adapter. This allows for setting the data on non-local storage so challenges
# and certs can work in a multi-server, load balanced environment.

set -e -u -x
HOOK_SERVER_PORT=11111

function deploy_challenge {
  local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

  curl --silent --show-error --fail -XPOST \
    --header "X-Hook-Secret: $HOOK_SECRET" \
    --data-urlencode "domain=$DOMAIN" \
    --data-urlencode "token_filename=$TOKEN_FILENAME" \
    --data-urlencode "token_value=$TOKEN_VALUE" \
    "http://127.0.0.1:$HOOK_SERVER_PORT/deploy-challenge"
}

function clean_challenge {
  local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
  # do nothing
}

function deploy_cert {
  local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"

  curl --silent --show-error --fail -XPOST \
    --header "X-Hook-Secret: $HOOK_SECRET" \
    --data "domain=$DOMAIN" \
    --data "privkey=$KEYFILE" \
    --data "cert=$CERTFILE" \
    --data "fullchain=$FULLCHAINFILE" \
    "http://127.0.0.1:$HOOK_SERVER_PORT/deploy-cert" || { echo "hook request failed"; exit 1; }
}

function unchanged_cert {
  local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}"

  curl --silent --show-error --fail -XPOST \
    --header "X-Hook-Secret: $HOOK_SECRET" \
    --data "domain=$DOMAIN" \
    --data "privkey=$KEYFILE" \
    --data "cert=$CERTFILE" \
    --data "fullchain=$FULLCHAINFILE" \
    "http://127.0.0.1:$HOOK_SERVER_PORT/deploy-cert" || { echo "hook request failed"; exit 1; }
}

function exit_hook {
  local TMP="exit hook"
  # do nothing
}

HANDLER=$1; shift; $HANDLER $@
