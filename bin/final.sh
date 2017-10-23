#!/usr/bin/env bash
## *************************************************************************
#   Deployment finalization (filesystem permissions)
#
#       This is friendly user script, not user friendly
#       There are no protection from mistakes.
#       Use it if you know how it works.
## *************************************************************************

# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../" && pwd`}



## *************************************************************************
#   Validate deployment mode and load configuration.
## *************************************************************************
MODE=${MODE}
IS_CHAINED="yes"       # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "${MODE}" ]; then
    MODE="work"
    IS_CHAINED="no"
fi

# check configuration file exists and load deployment config (db connection, Magento installation opts, etc.).
FILE_CFG=${DIR_ROOT}/cfg.${MODE}.sh
if [ -f "${FILE_CFG}" ]; then
    if [ "${IS_CHAINED}" = "no" ]; then    # this is standalone launch, load deployment configuration;
        echo "There is deployment configuration in ${FILE_CFG}."
        . ${FILE_CFG}
    fi
else
    if [ "${IS_CHAINED}" = "no" ]; then    # this is standalone launch w/o deployment configuration - exit;
        echo "There is no expected configuration in ${FILE_CFG}. Aborting..."
        cd ${DIR_CUR}
        exit 255
    fi
fi



## =========================================================================
#   Working variables and hardcoded configuration.
## =========================================================================

# Folders shortcuts
DIR_DEPLOY=${DIR_ROOT}/deploy       # folder with deployment templates
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application


# shortcuts to external vars (see ${FILE_CFG})
LOCAL_OWNER=${LOCAL_OWNER}
LOCAL_GROUP=${LOCAL_GROUP}
DIR_LINK_MEDIA=${DIR_LINK_MEDIA}
DIR_LINK_LOG=${DIR_LINK_LOG}



## =========================================================================
#   Mode specific finalization.
## =========================================================================
if [ "${OPT_SKIP_DB}" = "no" ]; then
. ${DIR_DEPLOY}/bin/app/final/${MODE}.sh
fi



echo ""
echo "************************************************************************"
echo "  Deployment finalization (common)."
echo "************************************************************************"

echo ""
if [ -z "${LOCAL_OWNER}" ] || [ -z "${LOCAL_GROUP}" ] || [ -z "${DIR_MAGE}" ]; then
    echo "Skip file system ownership and permissions setup."
else
    echo "Set file system ownership (${LOCAL_OWNER}:${LOCAL_GROUP}) and permissions to '${DIR_MAGE}'..."
    chown -R ${LOCAL_OWNER}:${LOCAL_GROUP} ${DIR_MAGE}
    find ${DIR_MAGE} -type d -exec chmod 770 {} \;
    find ${DIR_MAGE} -type f -exec chmod 660 {} \;
fi

# setup permissions for critical files/folders
chmod u+x ${DIR_MAGE}/bin/magento
chmod -R go-w ${DIR_MAGE}/app/etc

echo ""
echo "************************************************************************"
echo "  Deployment finalization (common) is complete."
echo "************************************************************************"