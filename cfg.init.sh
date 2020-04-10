#!/usr/bin/env bash
##
# Deployment descriptor. Set vars for deployment configuration here.
##
# https://stackoverflow.com/questions/49212475/composer-require-runs-out-of-memory-php-fatal-error-allowed-memory-size-of-161#49212550
export COMPOSER_MEMORY_LIMIT="-1" # Set unlimited memory for deployment with composer
export COMPOSER_FLAGS=""          # -v -n --profile

# runtime environment (is set automatically in './bin/commons.sh')
#export PHP_BIN="/usr/bin/php"           # change to "/usr/bin/php7.1" if you need special version of PHP
#export COMPOSER_BIN="/usr/bin/composer" # change to "/usr/bin/composer.version" if you need special version of composer

# configure runtime reporting & failsafe (see `./bin/commons.sh`)
#export DEBUG_MODE="1"
export FAILSAFE_MODE="1"

# keys to connect to repo with Magento2 sources (see './bin/deploy/mage.sh')
export MAGE_REPO_KEY_PUB="22f454163568cd5b08714ecdaa76d864"
export MAGE_REPO_KEY_PRIV="59b470101de30629b7be14702adf1682"
# OAuth token to connect to github
export GITHUB_OAUTH_TOKEN="2af2fb883302fd9ed2a80effea4765807df3e7a8"

# filesystem permissions
export LOCAL_OWNER="owner"
export LOCAL_GROUP="www-data"

# paths to folders with media & logs
export DIR_LINK_MEDIA="/home/user/store/project/media"
export DIR_LINK_LOG="/home/user/store/project/log"

# roots for backup, media and logs
export DIR_BAK="/home/user/store/project/bak"

# Magento 2 installation configuration
# see http://devdocs.magento.com/guides/v2.0/install-gde/install/cli/install-cli-install.html#instgde-install-cli-magento
export ADMIN_EMAIL="admin@store.com"
export ADMIN_FIRSTNAME="Store"
export ADMIN_LASTNAME="Admin"
export ADMIN_PASSWORD="..."
export ADMIN_USE_SECURITY_KEY="0"
export ADMIN_USER="admin"
export BACKEND_FRONTNAME="admin"
export BASE_URL="http://mage2.host.org:8080/"        # set trailing '/'
export BASE_URL_SECURE="http://mage2.host.org:8080/" # set trailing '/'
export CURRENCY="USD"
export DB_HOST="localhost"
export DB_NAME="mage2"
export DB_PASS="..."
export DB_USER="www"
export LANGUAGE="en_US"
export SECURE_KEY="..."
export SESSION_SAVE="db"
export TIMEZONE="UTC"
export USE_REWRITES="1"
export USE_SECURE="0"
export USE_SECURE_ADMIN="0"
