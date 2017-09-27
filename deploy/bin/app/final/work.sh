#!/usr/bin/env bash
## *************************************************************************
#   Finalize deployment.
## *************************************************************************

# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../../../" && pwd`}



## *************************************************************************
#   Validate deployment mode and load configuration.
## *************************************************************************
MODE=${MODE}
OPT_MAGE_RUN=${OPT_MAGE_RUN}
OPT_USE_EXIST_DB=${OPT_USE_EXIST_DB}
IS_CHAINED="yes"       # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "${MODE}" ]; then
    MODE="work"
    OPT_MAGE_RUN="developer"
    OPT_USE_EXIST_DB="yes"
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

# Folders shortcuts & other vars
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application



echo ""
echo "************************************************************************"
echo "  '${MODE}' mode deployment finalization."
echo "************************************************************************"
cd ${DIR_MAGE}

if [ "${OPT_MAGE_RUN}" = "developer" ]; then

    php ${DIR_MAGE}/bin/magento deploy:mode:set developer
    php ${DIR_MAGE}/bin/magento cache:disable
    php ${DIR_MAGE}/bin/magento setup:di:compile

else

    php ${DIR_MAGE}/bin/magento deploy:mode:set production

fi


# init own data if new database is created
if [ "${OPT_USE_EXIST_DB}" = "no" ]; then

    php ${DIR_MAGE}/bin/magento fl32:init:catalog
    php ${DIR_MAGE}/bin/magento fl32:init:customers
    php ${DIR_MAGE}/bin/magento fl32:init:sales

fi

# common tasks for 'work' mode
php ${DIR_MAGE}/bin/magento indexer:reindex
php ${DIR_MAGE}/bin/magento cron:run



echo ""
echo "************************************************************************"
echo "  '${MODE}' mode deployment finalization is completed."
echo "************************************************************************"


cd ${DIR_CUR}