#!/usr/bin/env bash
## *************************************************************************
#   Deploy Magento 2 itself
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
DIR_DEPLOY=${DIR_ROOT}/deploy       # folder with deployment templates
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application
MODE_WORK="work"



## =========================================================================
#   Prepare working environment.
## =========================================================================

# (re)create root folder for application deployment
if [ -d "${DIR_MAGE}" ]; then
    if [ "${MODE}" = "${MODE_WORK}" ]; then
        echo "Re-create '${DIR_MAGE}' folder."
        rm -fr ${DIR_MAGE}    # remove Magento root folder
        mkdir -p ${DIR_MAGE}  # ... then create it
    fi
else
    mkdir -p ${DIR_MAGE}      # just create folder if not exist
fi
echo "Magento will be installed into the '${DIR_MAGE}' folder."




## =========================================================================
#   Deploy Magento 2 itself using Composer.
## =========================================================================

echo ""
echo "Create M2 CE project in '${DIR_MAGE}' using composer"
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.2.0 ${DIR_MAGE}



echo ""
echo "************************************************************************"
echo "  Magento 2 code base is deployed."
echo "************************************************************************"