#!/usr/bin/env bash
## =========================================================================
#   Additional setup for database.
## =========================================================================
# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../../../" && pwd`}



## =========================================================================
#   Validate deployment mode and load configuration.
## =========================================================================
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
BASE_URL=${BASE_URL}
DB_HOST=${DB_HOST}
DB_NAME=${DB_NAME}
DB_PASS=${DB_PASS}
DB_PREFIX=${DB_PREFIX}
DB_USER=${DB_USER}

# this script's shortcuts
MYSQL_EXEC="mysql -h ${DB_HOST} -u ${DB_USER} --password=${DB_PASS} -D ${DB_NAME} -e "



## =========================================================================
#   Perform processing
## =========================================================================
echo ""
echo "************************************************************************"
echo "  Additional setup for database."
echo "************************************************************************"
${MYSQL_EXEC} "REPLACE INTO ${DB_PREFIX}core_config_data SET value = '1', path ='fl32_loginas/controls/customers_grid_action'"


echo ""
echo "************************************************************************"
echo "  Additional setup for database is completed."
echo "************************************************************************"
cd ${DIR_CUR}