#!/usr/bin/env bash
## =========================================================================
#   Init database.
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
: "${ADMIN_EMAIL:?}"
: "${ADMIN_FIRSTNAME:?}"
: "${ADMIN_LASTNAME:?}"
: "${ADMIN_PASSWORD:?}"
: "${ADMIN_USE_SECURITY_KEY:?}"
: "${ADMIN_USER:?}"
: "${BACKEND_FRONTNAME:?}"
: "${BASE_URL:?}"
: "${BASE_URL_SECURE:?}"
: "${CURRENCY:?}"
: "${DB_HOST:?}"
: "${DB_NAME:?}"
: "${DB_PASS:?}"
: "${DB_USER:?}"
: "${DIR_MAGE:?}"
: "${LANGUAGE:?}"
: "${MAGE_REPO_KEY_PRIV:?}"
: "${MAGE_REPO_KEY_PUB:?}"
: "${OPT_DB_DEMO:-no}"
: "${OPT_DB_NEW:-no}"
: "${PHP_BIN:?}"
: "${SECURE_KEY:?}"
: "${SESSION_SAVE:?}"
: "${TIMEZONE:?}"
: "${USE_REWRITES:?}"
: "${USE_SECURE:?}"
: "${USE_SECURE_ADMIN:?}"
# local context vars
MYSQLADMIN_BIN="${MYSQLADMIN_BIN:-$(whereis -b mysqladmin | cut -d" " -f2)}"

## =========================================================================
#   Perform processing
## =========================================================================
info ""
info "************************************************************************"
info "  Database initialization."
info "************************************************************************"

if test "${OPT_DB_NEW}" = "yes"; then

  info "Setup Magento to use new DB ('${DB_NAME}@${DB_HOST}' as '${DB_USER}')."

  info "Drop DB '${DB_NAME}'."
  ${MYSQLADMIN_BIN} -f -u"${DB_USER}" -p"${DB_PASS}" -h"${DB_HOST}" drop "${DB_NAME}"
  info "Create DB '${DB_NAME}'."
  ${MYSQLADMIN_BIN} -f -u"${DB_USER}" -p"${DB_PASS}" -h"${DB_HOST}" create "${DB_NAME}"
  info "DB '${DB_NAME}' is created."

  if test "${OPT_DB_DEMO}" = "yes"; then
    info "Add packages with sample data to Magento."
    ${PHP_BIN} "${DIR_MAGE}/bin/magento" "sampledata:deploy"
  fi

  info "Setup Magento and create DB structures."
  # https://devdocs.magento.com/guides/v2.3/install-gde/install/cli/install-cli-install.html
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" setup:install \
    --admin-email="${ADMIN_EMAIL}" \
    --admin-firstname="${ADMIN_FIRSTNAME}" \
    --admin-lastname="${ADMIN_LASTNAME}" \
    --admin-password="${ADMIN_PASSWORD}" \
    --admin-use-security-key="${ADMIN_USE_SECURITY_KEY}" \
    --admin-user="${ADMIN_USER}" \
    --backend-frontname="${BACKEND_FRONTNAME}" \
    --base-url-secure="${BASE_URL_SSL}" \
    --base-url="${BASE_URL}" \
    --cleanup-database \
    --currency="${CURRENCY}" \
    --db-host="${DB_HOST}" \
    --db-name="${DB_NAME}" \
    --db-password="${DB_PASS}" \
    --db-user="${DB_USER}" \
    --key="${SECURE_KEY}" \
    --language="${LANGUAGE}" \
    --session-save="${SESSION_SAVE}" \
    --timezone="${TIMEZONE}" \
    --use-rewrites="${USE_REWRITES}" \
    --use-secure-admin="${USE_SECURE_ADMIN}" \
    --use-secure="${USE_SECURE}"

else

  info "Setup Magento to use existing DB ('${DB_NAME}@${DB_HOST}' as '${DB_USER}')."
  # https://devdocs.magento.com/guides/v2.3/install-gde/install/cli/install-cli-install.html
  ${PHP_BIN} "${DIR_MAGE}/bin/magento" setup:install \
    --admin-email="${ADMIN_EMAIL}" \
    --admin-firstname="${ADMIN_FIRSTNAME}" \
    --admin-lastname="${ADMIN_LASTNAME}" \
    --admin-password="${ADMIN_PASSWORD}" \
    --admin-use-security-key="${ADMIN_USE_SECURITY_KEY}" \
    --admin-user="${ADMIN_USER}" \
    --backend-frontname="${BACKEND_FRONTNAME}" \
    --base-url="${BASE_URL}" \
    --base-url-secure="${BASE_URL_SSL}" \
    --db-host="${DB_HOST}" \
    --db-name="${DB_NAME}" \
    --db-password="${DB_PASS}" \
    --db-user="${DB_USER}" \
    --key="${SECURE_KEY}" \
    --session-save="${SESSION_SAVE}" \
    --use-rewrites="${USE_REWRITES}" \
    --use-secure-admin="${USE_SECURE_ADMIN}" \
    --use-secure="${USE_SECURE}"

fi

info ""
info "************************************************************************"
info "  Database initialization is completed."
info "************************************************************************"
