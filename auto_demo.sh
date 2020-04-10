#!/usr/bin/env bash
## =========================================================================
#   Install Magento2 Sample App in 'live' mode.
#   Re-create DB and fill it with sample data.
## =========================================================================
git checkout master
sh "${DIR_ROOT}/deploy/main.sh" -d live -n -i
