#!/usr/bin/env bash
## =========================================================================
#   Setup composer to build the project.
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
: "${GITHUB_OAUTH_TOKEN:?}"
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
info "  Configure composer to build the project."
info "************************************************************************"
cd "${DIR_MAGE}" || exit 255
info "Force 'packagist.org' usage (if '.com' was used before)."
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config repo.packagist composer https://packagist.org

# populate composer.json (common actions for both modes - work & live)
info "Setup composer related environment (project level):"

# Script './bin/magento' uses local 'auth.json'
info "  setup local access to repo.magento.com (see https://marketplace.magento.com/customer/accessKeys/)."
cd "${DIR_MAGE}" || exit 255
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config \
  --auth http-basic.repo.magento.com \
  ${MAGE_REPO_KEY_PUB} \
  ${MAGE_REPO_KEY_PRIV}

info "    add github OAuth token."
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config github-oauth.github.com ${GITHUB_OAUTH_TOKEN}

info "    add local repo (3rd parties zipped modules)."
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config repositories.local \
  '{"type": "artifact", "url": "../repo/"}' # relative to root Mage dir

info "    add private 'vcs' repos."
${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config repositories.magento-l10n.language-lv_LV \
  vcs https://github.com/magento-l10n/language-lv_LV

#info "    add remote repo 'dist.aheadworks.com'."
#${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config repositories.aheadworks composer https://dist.aheadworks.com/
#${PHP_BIN} ${COMPOSER_BIN} ${COMPOSER_FLAGS} config http-basic.dist.aheadworks.com \
#  KEY_PUB \
#  KEY_PRIV

info ""
info "************************************************************************"
info "  Composer is configured."
info "************************************************************************"
