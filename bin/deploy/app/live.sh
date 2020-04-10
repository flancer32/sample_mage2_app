#!/usr/bin/env bash
## =========================================================================
#   Configure composer.json and install application modules ('live' mode)
## =========================================================================
# shellcheck disable=SC1090,SC2086
# root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=$(cd "$(dirname "$0")/../../../" && pwd)}

## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
if test -z "${MODE}"; then
  . "${DIR_ROOT}/bin/commons.sh" "live" # standalone running
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
: "${MODE:?}"
: "${MODE_WORK:?}"
: "${PHP_BIN:?}"
# local context vars

## =========================================================================
#   Perform processing
## =========================================================================
info ""
info "************************************************************************"
info "  Custom modules deployment."
info "************************************************************************"
cd "${DIR_MAGE}" || exit

info "Configure modules stability"
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config minimum-stability stable
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config "prefer-stable" true

info ""
info "Add own modules"
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} require \
  community-engineering/language-lv_lv \
  etws/magento-language-ru_ru \
  flancer32/mage2_ext_bot_sess \
  flancer32/mage2_ext_email_hijack \
  flancer32/mage2_ext_log_api \
  flancer32/mage2_ext_login_as \
  kiwicommerce/module-cron-scheduler \
  kiwicommerce/module-enhanced-smtp \

info ""
info "************************************************************************"
info "  Custom modules are deployed."
info "************************************************************************"
