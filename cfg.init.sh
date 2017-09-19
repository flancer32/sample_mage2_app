#!/usr/bin/env bash

# filesystem permissions
LOCAL_OWNER="owner"
LOCAL_GROUP="www-data"

# paths to folders with media & logs
DIR_LINK_MEDIA=
DIR_LINK_LOG=

# roots for backup, media and logs (for 'live' mode only)
DIR_BAK_DB=
DIR_BAK_MEDIA=

# cloning configuration - ssh access and paths (for 'work' mode only)
SSH_URL=
SSH_ROOT=

# Magento 2 installation configuration
# see http://devdocs.magento.com/guides/v2.0/install-gde/install/cli/install-cli-install.html#instgde-install-cli-magento
ADMIN_FIRSTNAME="Store"
ADMIN_LASTNAME="Admin"
ADMIN_EMAIL="admin@store.com"
ADMIN_USER="admin"
ADMIN_PASSWORD="..."
ADMIN_USE_SECURITY_KEY="0"
BASE_URL="http://mage2.host.org:8080/"
BACKEND_FRONTNAME="admin"
SECURE_KEY="..."
DB_HOST="localhost"
DB_NAME="mage2"
DB_USER="www"
DB_PASS="..."
LANGUAGE="en_US"
CURRENCY="USD"
TIMEZONE="UTC"
USE_REWRITES="0"
USE_SECURE="0"
USE_SECURE_ADMIN="0"
SESSION_SAVE="files"