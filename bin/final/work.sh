#!/usr/bin/env bash
## =========================================================================
#   Finalize deployment.
## =========================================================================
# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../" && pwd`}



## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
MODE=${MODE}
OPT_MAGE_RUN=${OPT_MAGE_RUN}
OPT_USE_EXIST_DB=${OPT_USE_EXIST_DB}
IS_CHAINED="yes"       # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "${MODE}" ]; then
    MODE="work"
    IS_CHAINED="no"
    OPT_MAGE_RUN="developer"
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
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application



## =========================================================================
#   Perform processing
## =========================================================================
echo ""
echo "************************************************************************"
echo "  '${MODE}' mode deployment finalization."
echo "************************************************************************"
##
# !!! apply mode specific patches before finalization routines
##
if [ "${OPT_MAGE_RUN}" = "developer" ]; then

    php ${DIR_MAGE}/bin/magento deploy:mode:set developer
    php ${DIR_MAGE}/bin/magento cache:enable
    php ${DIR_MAGE}/bin/magento setup:di:compile

else

    php ${DIR_MAGE}/bin/magento deploy:mode:set production
    php ${DIR_MAGE}/bin/magento cache:enable

fi

# common tasks for 'work' mode
php ${DIR_MAGE}/bin/magento indexer:reindex
php ${DIR_MAGE}/bin/magento cron:run



echo ""
echo "************************************************************************"
echo "  '${MODE}' mode deployment finalization is completed."
echo "************************************************************************"
cd ${DIR_CUR}