#!/usr/bin/env bash
## =========================================================================
#   Application data initialization.
## =========================================================================
# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../" && pwd`}



## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
MODE=${MODE}
IS_CHAINED="yes"       # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "${MODE}" ]; then
    MODE="work"
    IS_CHAINED="no"
    OPT_USE_EXIST_DB="yes"
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
DIR_MAGE=${DIR_ROOT}/${MODE}                # root folder for Magento application

# command line arguments
OPT_USE_EXIST_DB=${OPT_USE_EXIST_DB}



## =========================================================================
#   Perform processing
## =========================================================================
echo ""
echo "************************************************************************"
echo "  Application data initialization."
echo "************************************************************************"
# init data if new database is created
#if [ "${OPT_USE_EXIST_DB}" = "no" ]; then

#    php ${DIR_MAGE}/bin/magento fl32:init:catalog
#    php ${DIR_MAGE}/bin/magento fl32:init:customers
#    php ${DIR_MAGE}/bin/magento fl32:init:sales

#fi



echo ""
echo "************************************************************************"
echo "  Application data initialization is completed."
echo "************************************************************************"
cd ${DIR_CUR}