#!/usr/bin/env bash
## =========================================================================
#   Finalize deployment in 'live' mode.
## =========================================================================
# shellcheck disable=SC1090
# root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=$(cd "$(dirname "$0")/../../../" && pwd)}

## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
if test -z "${MODE}"; then
  . "${DIR_ROOT}/bin/commons.sh" "${1}" # standalone running (./script.sh [work|live])
else
  . "${DIR_ROOT}/bin/commons.sh" # this script is child of other script
fi

## =========================================================================
#   Setup working environment
## =========================================================================
: "${DIR_MAGE:?}"
: "${ENV_REDIS_DB:?}"
: "${PHP_BIN:?}"
# local context vars

## =========================================================================
#   Perform processing
## =========================================================================
info ""
info "************************************************************************"
info "  '${MODE}' mode deployment finalization."
info "************************************************************************"

info "Adding Redis cache to app config..."
${PHP_BIN} "${DIR_MAGE}/bin/magento" setup:config:set -n \
  --cache-backend=redis \
  --cache-backend-redis-db="${ENV_REDIS_DB}"

info "Create log files."
touch "${DIR_MAGE}/var/log/api.log"
touch "${DIR_MAGE}/var/log/connector.log"
touch "${DIR_MAGE}/var/log/cron.log"
touch "${DIR_MAGE}/var/log/debug.log"
touch "${DIR_MAGE}/var/log/exception.log"
touch "${DIR_MAGE}/var/log/fl32.botsess.log"
touch "${DIR_MAGE}/var/log/system.log"

info "Perform maintenance routines (cache, mode, index, cron)"
${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:enable
${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:flush
${PHP_BIN} "${DIR_MAGE}/bin/magento" deploy:mode:set production
${PHP_BIN} "${DIR_MAGE}/bin/magento" indexer:reindex
${PHP_BIN} "${DIR_MAGE}/bin/magento" cron:run

info ""
info "************************************************************************"
info "  '${MODE}' mode deployment finalization is completed."
info "************************************************************************"
