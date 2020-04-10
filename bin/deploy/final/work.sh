#!/usr/bin/env bash
## =========================================================================
#   Finalize deployment in 'work' mode.
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
: "${OPT_MAGE_RUN:?}"
: "${PHP_BIN:?}"
# local context vars

## =========================================================================
#   Perform processing
## =========================================================================
info ""
info "************************************************************************"
info "  '${MODE}' mode deployment finalization."
info "************************************************************************"
##
# !!! apply mode specific patches before finalization routines
##
if test "${OPT_MAGE_RUN}" = "developer"; then

  ${PHP_BIN} "${DIR_MAGE}/bin/magento" deploy:mode:set developer
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:enable
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" setup:di:compile

else

  ${PHP_BIN} "${DIR_MAGE}/bin/magento" deploy:mode:set production
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:enable
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:flush

fi

# common tasks for 'work' mode
${PHP_BIN} "${DIR_MAGE}/bin/magento" indexer:reindex
${PHP_BIN} "${DIR_MAGE}/bin/magento" cron:run

info ""
info "************************************************************************"
info "  '${MODE}' mode deployment finalization is completed."
info "************************************************************************"
