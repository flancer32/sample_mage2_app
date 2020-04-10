#!/usr/bin/env bash
## =========================================================================
#   Finalize Magento based application deployment.
#
#       This is friendly user script, not user friendly
#       There are no protection from mistakes.
#       Use it if you know how it works.
## =========================================================================
# shellcheck disable=SC1090
# root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT=${DIR_ROOT:=$(cd "$(dirname "$0")/../../" && pwd)}

## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
if test -z "${MODE}"; then
  . "${DIR_ROOT}/bin/commons.sh" "${1}" # standalone running (./script.sh [work|live])
else
  . "${DIR_ROOT}/bin/commons.sh" # this script is child of other script
fi

## =========================================================================
#   Setup & validate working environment
## =========================================================================
: "${DIR_DEPLOY:?}"
: "${DIR_LINK_LOG:?}"
: "${DIR_LINK_MEDIA:?}"
: "${DIR_MAGE:?}"
: "${LOCAL_GROUP:?}"
: "${LOCAL_OWNER:?}"
# local context vars

## =========================================================================
#   Perform processing
## =========================================================================
info ""
info "************************************************************************"
info "  Deployment finalization."
info "************************************************************************"
cd "${DIR_ROOT}" || exit 255

info "Disable some Magento modules."
${PHP_BIN} "${DIR_MAGE}/bin/magento" module:disable --clear-static-content \
  Dotdigitalgroup_Email \
  Dotdigitalgroup_Chat \
  Temando_Shipping

info "Perorm maintanance tasks according to Magento mode (${OPT_MAGE_RUN})."
if test "${OPT_MAGE_RUN}" = "developer"; then

  ${PHP_BIN} "${DIR_MAGE}/bin/magento" deploy:mode:set developer
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:enable
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" setup:di:compile

else

  info "Adding Redis cache to app config..."
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" setup:config:set -n \
    --cache-backend=redis

  ${PHP_BIN} "${DIR_MAGE}/bin/magento" deploy:mode:set production
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:enable
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" cache:flush

fi

info "Common tasks for all modes."
${PHP_BIN} "${DIR_MAGE}/bin/magento" indexer:reindex
${PHP_BIN} "${DIR_MAGE}/bin/magento" cron:run

info "Setup permissions to filesystem."
info ""
if test -z "${LOCAL_OWNER}" || test -z "${LOCAL_GROUP}" || test -z "${DIR_MAGE}"; then
  info "Skip file system ownership and permissions setup."
else
  info "Set file system ownership (${LOCAL_OWNER}:${LOCAL_GROUP}) and permissions to '${DIR_MAGE}'..."
  chown -R "${LOCAL_OWNER}":"${LOCAL_GROUP}" "${DIR_MAGE}"
  find "${DIR_MAGE}" -type d -exec chmod 770 {} \;
  find "${DIR_MAGE}" -type f -exec chmod 660 {} \;
fi

# setup permissions for critical files/folders
chmod u+x "${DIR_MAGE}/bin/magento"
chmod -R go-w "${DIR_MAGE}/app/etc"

info ""
info "************************************************************************"
info "  Deployment finalization is complete."
info "************************************************************************"
