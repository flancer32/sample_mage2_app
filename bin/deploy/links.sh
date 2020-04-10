#!/usr/bin/env bash
## =========================================================================
#   Create symlinks to logs and media (these folders are not rotated).
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
info "  Create symlinks for media & logs."
info "************************************************************************"
# link media folder
if test -z "${DIR_LINK_MEDIA}"; then
  info "Variable 'DIR_LINK_MEDIA' is not set. Re-link folder with media manually."
else
  mkdir -p "${DIR_LINK_MEDIA}"
  cd "${DIR_MAGE}/pub/" || exit 255
  if test -d "./media" && test ! -d "./media.orig"; then
    info "Move ${DIR_MAGE}/pub/media/ to ${DIR_MAGE}/pub/media.orig/ "
    mv ./media ./media.orig
  fi
  if test ! -L "./media"; then
    info "Re-link './media' to ${DIR_LINK_MEDIA}/"
    ln -s "${DIR_LINK_MEDIA}" media
  fi
#  There is exit on error if "chown" changes permissions w/o owner access.
#  info "Set file system ownership (${LOCAL_OWNER}:${LOCAL_GROUP}) and permissions to '${DIR_LINK_MEDIA}'..."
#  chown -f -R "${LOCAL_OWNER}":"${LOCAL_GROUP}" "${DIR_LINK_MEDIA}"
fi
# link logs folder
if test -z "${DIR_LINK_LOG}"; then
  info "Variable 'DIR_LINK_LOG' is not set. Re-link folder for logs manually."
else
  mkdir -p "${DIR_LINK_LOG}"
  cd "${DIR_MAGE}/var/" || exit 255
  if test -d "./log" && test ! -d "./log.orig"; then
    info "Move ${DIR_MAGE}/var/log/ to ${DIR_MAGE}/var/log.orig/ "
    mv ./log ./log.orig
  fi
  if test ! -L "./log"; then
    info "Re-link './log' to ${DIR_LINK_LOG}/"
    ln -s "${DIR_LINK_LOG}" log
  fi
#  There is exit on error if "chown" changes permissions w/o owner access.
#  info "Set file system ownership (${LOCAL_OWNER}:${LOCAL_GROUP}) and permissions to '${DIR_LINK_LOG}'..."
#  chown -f -R "${LOCAL_OWNER}":"${LOCAL_GROUP}" "${DIR_LINK_LOG}"
fi

info ""
info "************************************************************************"
info "  Symlinks for media & logs are created."
info "************************************************************************"
