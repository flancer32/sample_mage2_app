#!/usr/bin/env bash
## =========================================================================
#   Deploy web application (Mage, modules, patches, DB, ...).
#
#       This is friendly user script, not user friendly
#       There are no protection from mistakes.
#       Use it if you know how it works.
## =========================================================================
# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../" && pwd`}



## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
MODE=${MODE}
IS_CHAINED="yes"       # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "$MODE" ]; then
    MODE="work"
    IS_CHAINED="no"
    OPT_SKIP_DB="yes"
fi

# check configuration file exists and load deployment config (db connection, Magento installation opts, etc.).
FILE_CFG=${DIR_ROOT}/cfg.${MODE}.sh
if [ -f "${FILE_CFG}" ]; then
    if [ "${IS_CHAINED}" = "no" ]; then    # this is standalone launch, load deployment configuration;
        echo "There is deployment configuration in ${FILE_CFG}."
        . ${FILE_CFG}
    # else: deployment configuration should be loaded before
    fi
else
    echo "There is no expected configuration in ${FILE_CFG}. Aborting..."
    cd ${DIR_CUR}
    exit 255
fi



## =========================================================================
#   Setup working environment
## =========================================================================
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application

# deployment configuration (see ${FILE_CFG})
DIR_LINK_LOG=${DIR_LINK_LOG}
DIR_LINK_MEDIA=${DIR_LINK_MEDIA}
LOCAL_GROUP=${LOCAL_GROUP}
LOCAL_OWNER=${LOCAL_OWNER}
OPT_SKIP_DB=${OPT_SKIP_DB}



## =========================================================================
#   Perform processing
## =========================================================================
# Deploy Magento 2 itself
. ${DIR_ROOT}/bin/app/mage.sh

# Deploy custom modules with Composer (according to deploy mode)
. ${DIR_ROOT}/bin/app/own/${MODE}.sh

# Copy theme files
. ${DIR_ROOT}/bin/app/theme.sh

# Apply patches to the code
. ${DIR_ROOT}/bin/app/patch.sh

# Setup database for the application
if [ "${OPT_SKIP_DB}" = "yes" ]; then
    echo ""
    echo "************************************************************************"
    echo "  Database initialization is skipped (use Web UI to create DB)."
    echo "************************************************************************"
else
    . ${DIR_ROOT}/bin/app/db/${MODE}.sh
fi



echo ""
echo "************************************************************************"
echo "  Web application deployment is complete."
echo "************************************************************************"
cd ${DIR_CUR}