#!/usr/bin/env bash
## =========================================================================
#   Deploy Magento 2 empty application (w/o additional modules).
## =========================================================================
# shellcheck disable=SC1090,SC2086
# root directory (set before or relative to the current shell script)
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
# check external vars used in this script (see cfg.[work|live].sh)
: "${COMPOSER_BIN:?}"
: "${COMPOSER_FLAGS:-}"
: "${DIR_MAGE:?}"
: "${MAGE_REPO_KEY_PRIV:?}"
: "${MAGE_REPO_KEY_PUB:?}"
: "${MODE:?}"
: "${MODE_WORK:?}"
: "${PHP_BIN:?}"
# local context vars

## =========================================================================
#   Perform processing
## =========================================================================
info ""
info "************************************************************************"
info "  Deploy Magento 2 code base."
info "************************************************************************"
# (re)create root folder for application deployment
if test -d "${DIR_MAGE}"; then
  if test "${MODE}" = "${MODE_WORK}"; then
    info "Re-create '${DIR_MAGE}' folder."
    rm -fr "${DIR_MAGE}"   # remove Magento root folder
    mkdir -p "${DIR_MAGE}" # ... then create it
  fi
else
  mkdir -p "${DIR_MAGE}" # just create folder if not exist
fi
info "Magento will be installed into the '${DIR_MAGE}' folder."

info "Setup composer access to repo.magento.com (see https://marketplace.magento.com/customer/accessKeys/)."
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config --global \
  --auth http-basic.repo.magento.com \
  ${MAGE_REPO_KEY_PUB} \
  ${MAGE_REPO_KEY_PRIV}

# deploy Magento 2 itself using Composer
info ""
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config --global repo.packagist composer https://packagist.org
info "Create M2 CE project in '${DIR_MAGE}' using composer"
time "${PHP_BIN}" "${COMPOSER_BIN}" ${COMPOSER_FLAGS} \
  --repository-url=https://repo.magento.com/ \
  create-project \
  magento/project-community-edition=^2.3 \
  "${DIR_MAGE}"

# setup permissions to filesystem
info ""
if test -z "${LOCAL_OWNER}" || test -z "${LOCAL_GROUP}" || test -z "${DIR_MAGE}"; then
  info "Skip file system ownership and permissions setup."
else
  info "Set file system ownership (${LOCAL_OWNER}:${LOCAL_GROUP}) to '${DIR_MAGE}'..."
  chown -fR "${LOCAL_OWNER}":"${LOCAL_GROUP}" "${DIR_MAGE}"
fi

info ""
info "************************************************************************"
info "  Magento 2 code base is deployed."
info "************************************************************************"
