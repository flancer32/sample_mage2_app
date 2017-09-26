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
ADMIN_EMAIL="admin@store.com"
ADMIN_FIRSTNAME="Store"
ADMIN_LASTNAME="Admin"
ADMIN_PASSWORD="..."
ADMIN_USE_SECURITY_KEY="0"
ADMIN_USER="admin"
BACKEND_FRONTNAME="admin"
BASE_URL="http://mage2.host.org:8080/"
CURRENCY="USD"
DB_HOST="localhost"
DB_NAME="mage2"
DB_PASS="..."
DB_USER="www"
LANGUAGE="en_US"
SECURE_KEY="..."
SESSION_SAVE="files"
TIMEZONE="UTC"
USE_REWRITES="0"
USE_SECURE="0"
USE_SECURE_ADMIN="0"
