#!/usr/bin/env bash
## =========================================================================
#   Install Magento2 Sample App in 'live' mode.
#   Re-create DB and fill it with sample data.
## =========================================================================
# root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT="$(cd "$(dirname "$0")" && pwd)"
git checkout master

"${DIR_ROOT}/bin/deploy/main.sh" -d live -n -i
