#!/usr/bin/env bash
## *************************************************************************
#   Init database.
## *************************************************************************

# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../../" && pwd`}



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

# Folders shortcuts & other vars
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application
OPT_SKIP_DB=${OPT_SKIP_DB}



if [ "${OPT_SKIP_DB}" = "yes" ]; then


    echo ""
    echo "************************************************************************"
    echo "  Database initialization is skipped."
    echo "************************************************************************"


else


    echo ""
    echo "************************************************************************"
    echo "  Database initialization."
    echo "************************************************************************"
    cd ${DIR_MAGE}



    echo ""
    echo "************************************************************************"
    echo "  Database initialization is completed."
    echo "************************************************************************"


fi
cd ${DIR_CUR}