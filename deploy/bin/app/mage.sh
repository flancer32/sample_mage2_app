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
if [ -z "${MODE}" ]; then
    MODE=work
    echo "Default mode '${MODE}' is used for Magento 2 code base deployment."
else
    echo "Magento 2 code base deployment mode: ${MODE}"
fi

# check configuration file exists and load deployment config (db connection, Magento installation opts, etc.).
FILE_CFG=${DIR_ROOT}/cfg.${MODE}.sh
if [ -f "${FILE_CFG}" ]
then
    echo "There is deployment configuration in ${FILE_CFG}."
    . ${FILE_CFG}
else
    echo "There is no expected configuration in ${FILE_CFG}. Aborting..."
    cd ${DIR_CUR}
    exit 255
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
    if [ "$MODE"=="${MODE_WORK}" ]; then
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
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.2.0-rc30 ${DIR_MAGE}



echo ""
echo "************************************************************************"
echo "  Magento 2 code base is deployed."
echo "************************************************************************"