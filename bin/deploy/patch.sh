#!/usr/bin/env bash
## =========================================================================
#   Apply patches on code (Magento & own).
## =========================================================================
# shellcheck disable=SC1090
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
: "${DIR_MAGE:?}"
# local context vars
DIR_PATCH=${DIR_ROOT}/patch # root folder for patches

## =========================================================================
#   Perform processing.
## =========================================================================
info ""
info "************************************************************************"
info "  Apply patches to the code."
info "************************************************************************"
cd "${DIR_MAGE}" || exit 255

info "Patch: setup './pub/' as root folder for Magento app."
patch -p1 <"${DIR_PATCH}/use_pub_as_root.patch"

info ""
info "************************************************************************"
info "  Patches are applied."
info "************************************************************************"
