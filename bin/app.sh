#!/usr/bin/env bash
## *************************************************************************
#   Deploy web application (Mage, DB, modules, patches, ...).
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
if [ -z "$MODE" ]; then
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
#   Deploy Magento 2 itself.
## =========================================================================
. ${DIR_DEPLOY}/bin/app/mage.sh



## =========================================================================
#   Deploy custom modules with Composer (according to deploy mode).
## =========================================================================
. ${DIR_DEPLOY}/bin/app/own/${MODE}.sh



## =========================================================================
#   Setup database for the application.
## =========================================================================
if [ "${OPT_SKIP_DB}" = "yes" ]; then
    echo ""
    echo "************************************************************************"
    echo "  Database initialization is skipped."
    echo "************************************************************************"
else
    . ${DIR_DEPLOY}/bin/app/db/${MODE}.sh
fi



echo ""
echo "************************************************************************"
echo "  Web application deployment is complete."
echo "************************************************************************"