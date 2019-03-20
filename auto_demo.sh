#!/usr/bin/env bash
## =========================================================================
#   Deploy test application (WORK mode).
## =========================================================================
# pin current folder and deployment root folder
DIR_CUR="$PWD"
# root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT="$( cd "$( dirname "$0" )" && pwd )"

##
#       Install Magento2 Sample App
##
git checkout master
sh ${DIR_ROOT}/deploy.sh

##
#       Add own module
##
DIR_MAGE=${DIR_ROOT}/work

#php ${DIR_MAGE}/bin/magento fl32:init:catalog
#php ${DIR_MAGE}/bin/magento fl32:init:customers
#php ${DIR_MAGE}/bin/magento fl32:init:sales


##
#       Perform maintenance procedures
##
php ${DIR_MAGE}/bin/magento indexer:reindex
php ${DIR_MAGE}/bin/magento cron:run

cd ${DIR_CUR}
