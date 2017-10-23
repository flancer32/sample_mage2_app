#!/usr/bin/env bash
## *************************************************************************
#   Init database.
## *************************************************************************

# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../../../" && pwd`}



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

OPT_USE_EXIST_DB=${OPT_USE_EXIST_DB}

ADMIN_EMAIL=${ADMIN_EMAIL}
ADMIN_FIRSTNAME=${ADMIN_FIRSTNAME}
ADMIN_LASTNAME=${ADMIN_LASTNAME}
ADMIN_PASSWORD=${ADMIN_PASSWORD}
ADMIN_USE_SECURITY_KEY=${ADMIN_USE_SECURITY_KEY}
ADMIN_USER=${ADMIN_USER}
BACKEND_FRONTNAME=${BACKEND_FRONTNAME}
BASE_URL=${BASE_URL}
CURRENCY=${CURRENCY}
DB_HOST=${DB_HOST}
DB_NAME=${DB_NAME}
DB_PASS=${DB_PASS}
DB_USER=${DB_USER}
LANGUAGE=${LANGUAGE}
SECURE_KEY=${SECURE_KEY}
SESSION_SAVE=${SESSION_SAVE}
TIMEZONE=${TIMEZONE}
USE_REWRITES=${USE_REWRITES}
USE_SECURE=${USE_SECURE}
USE_SECURE_ADMIN=${USE_SECURE_ADMIN}



echo ""
echo "************************************************************************"
echo "  Database initialization."
echo "************************************************************************"
cd ${DIR_MAGE}

if [ "${OPT_USE_EXIST_DB}" = "no" ]; then

    echo "Drop DB '${DB_NAME}'."
    mysqladmin -f -u"${DB_USER}" -p"${DB_PASS}" -h"${DB_HOST}" drop "${DB_NAME}"
    echo "Create DB '${DB_NAME}'."
    mysqladmin -f -u"${DB_USER}" -p"${DB_PASS}" -h"${DB_HOST}" create "${DB_NAME}"
    echo "DB '${DB_NAME}' is created."

    # Full list of the available options:
    # http://devdocs.magento.com/guides/v2.0/install-gde/install/cli/install-cli-install.html#instgde-install-cli-magento
    php ${DIR_MAGE}/bin/magento setup:install  \
    --admin-firstname="${ADMIN_FIRSTNAME}" \
    --admin-lastname="${ADMIN_LASTNAME}" \
    --admin-email="${ADMIN_EMAIL}" \
    --admin-user="${ADMIN_USER}" \
    --admin-password="${ADMIN_PASSWORD}" \
    --base-url="${BASE_URL}" \
    --backend-frontname="${BACKEND_FRONTNAME}" \
    --key="${SECURE_KEY}" \
    --language="${LANGUAGE}" \
    --currency="${CURRENCY}" \
    --timezone="${TIMEZONE}" \
    --use-rewrites="${USE_REWRITES}" \
    --use-secure="${USE_SECURE}" \
    --use-secure-admin="${USE_SECURE_ADMIN}" \
    --admin-use-security-key="${ADMIN_USE_SECURITY_KEY}" \
    --session-save="${SESSION_SAVE}" \
    --cleanup-database \
    --db-host="${DB_HOST}" \
    --db-name="${DB_NAME}" \
    --db-user="${DB_USER}" \
    --db-password="${DB_PASS}"

else

    echo "Setup Magento to use existing DB (${DB_NAME}@${DB_HOST} as ${DB_USER})."
    php ${DIR_MAGE}/bin/magento setup:install  \
    --admin-firstname="${ADMIN_FIRSTNAME}" \
    --admin-lastname="${ADMIN_LASTNAME}" \
    --admin-email="${ADMIN_EMAIL}" \
    --admin-user="${ADMIN_USER}" \
    --admin-password="${ADMIN_PASSWORD}" \
    --backend-frontname="${BACKEND_FRONTNAME}" \
    --key="${SECURE_KEY}" \
    --session-save="${SESSION_SAVE}" \
    --db-host="${DB_HOST}" \
    --db-name="${DB_NAME}" \
    --db-user="${DB_USER}" \
    --db-password="${DB_PASS}"

fi

echo ""
echo "Additional DB setup."
MYSQL_EXEC="mysql -u ${DB_USER} --password=${DB_PASS} -D ${DB_NAME} -e "
${MYSQL_EXEC} "REPLACE INTO core_config_data SET value = '1', path ='fl32_loginas/controls/customers_grid_action'"

echo ""
echo "************************************************************************"
echo "  Database initialization is completed."
echo "************************************************************************"


cd ${DIR_CUR}