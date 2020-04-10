#!/usr/bin/env bash
## =========================================================================
#   Deployment script for Magento 2 based apps.
#
#       This is friendly user script, not user friendly
#       There are no protection from mistakes.
#       Use it if you know how it works.
## =========================================================================
# shellcheck disable=SC1090
# root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT=${DIR_ROOT:=$(cd "$(dirname "$0")/../../" && pwd)}

##
# Export working vars to use in subprocesses.
##
export DIR_ROOT

##
# Default configuration (this script usage only).
##
OPT_CLI_HELP="no" # -h print out help
OPT_DB_DEMO="no"  # -i fill DB with demo data
OPT_DB_NEW="no"   # -n re-create DB
OPT_MODE="work"   # -d deployment mode: work|live

## =========================================================================
#   Parse input options
## =========================================================================
while getopts "d:hin" OPTNAME; do
  case "${OPTNAME}" in
  "d") OPT_MODE=${OPTARG} ;;
  "i") export OPT_DB_DEMO="yes" ;;
  "n") export OPT_DB_NEW="yes" ;;
  "*") OPT_CLI_HELP="yes" ;;
  esac
done

## =========================================================================
#   Print out help
## =========================================================================
if test "${OPT_CLI_HELP}" = "yes"; then
  echo "Deployment script for Magento2 based application."
  echo ""
  echo "Usage: sh main.sh -d [work|live] -n"
  echo ""
  echo "Where:"
  echo "  -d: Deployment mode ([work|live], default: work);"
  echo "  -h: This output;"
  echo "  -i: Fill Magento DB with demo data;"
  echo "  -n: Re-create Magento DB;"
  exit 0
fi

## =========================================================================
#   Validate current deployment mode (work|live), load common functionality
#   and deployment configuration.
## =========================================================================
. "${DIR_ROOT}/bin/commons.sh" "${OPT_MODE}"

info "====================================================================="
info "Start deployment with following options:"
info "    Application deployment mode:          '${MODE}'"
info "    Re-create Magento DB:                 '${OPT_DB_NEW}'"
info "    Fill Magento DB with sample data:     '${OPT_DB_DEMO}'"
info "====================================================================="

## =========================================================================
#   Setup & validate working environment
## =========================================================================
# check external vars used in this script (see cfg.[work|live].sh)
: "${BACKEND_FRONTNAME:?}"
: "${BASE_URL:?}"
: "${DIR_DEPLOY:?}"
: "${MODE:?}"
: "${MODE_LIVE:?}"

# don't replace `./live/` folder programmatically
if test "${MODE}" = "${MODE_LIVE}" && test -d "${DIR_MAGE}"; then
  info "There is '${DIR_MAGE}' in '${MODE_LIVE}' mode. Remove folder manually if you want to deploy."
  exit 2
fi

## =========================================================================
#   Perform processing
## =========================================================================
cd "${DIR_ROOT}" || exit 255
# Deploy Magento 2 itself
/bin/bash "${DIR_DEPLOY}/mage.sh"
# Create symlinks (media, logs, etc.)
/bin/bash "${DIR_DEPLOY}/links.sh"
# Configure 'composer' (access to other repositories)
/bin/bash "${DIR_DEPLOY}/composer.sh"
# Connect application to DB
/bin/bash "${DIR_DEPLOY}/db.sh"
# Deploy application modules according to deploy mode
/bin/bash "${DIR_DEPLOY}/app/${MODE}.sh"
# Apply patches to the code
/bin/bash "${DIR_DEPLOY}/patch.sh"
# Finalize deployment (perform common tasks then mode related tasks)
/bin/bash "${DIR_DEPLOY}/final.sh"

info ""
info "Application deployment in '${OPT_MODE}' mode  is done."
info "  Frontend: ${BASE_URL}"
info "  Backend:  ${BASE_URL}${BACKEND_FRONTNAME}"
info ""
