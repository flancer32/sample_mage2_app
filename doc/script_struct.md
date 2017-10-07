# Structure of the shell scripts

Shell scripts have the common structure in this sample.

## Pin directories

```bash
# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (relative to the current shell script, not to the execution point)
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../" && pwd`}
```
`DIR_CUR` is used as point to return to when script is launched as standalone.


## Validate deployment mode and load configuration

```bash
MODE=${MODE}            # ${MODE} should be set before if script is launched in chain with other scripts
IS_CHAINED="yes"        # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "$MODE" ]; then
    MODE="work"         # setup default values for standalone launches
    IS_CHAINED="no"
fi

# check configuration file exists and load deployment config (db connection, Magento installation opts, etc.).
FILE_CFG=${DIR_ROOT}/cfg.${MODE}.sh
if [ -f "${FILE_CFG}" ]; then
    if [ "${IS_CHAINED}" = "no" ]; then    # this is standalone launch, load deployment configuration;
        echo "There is deployment configuration in ${FILE_CFG}."
        . ${FILE_CFG}
    # else: deployment configuration should be loaded before
    fi
else
    echo "There is no expected configuration in ${FILE_CFG}. Aborting..."
    cd ${DIR_CUR}
    exit 255
fi
```


## Setup working environment

```bash
# shortcuts to external vars (see ${FILE_CFG})
LOCAL_OWNER=${LOCAL_OWNER}
LOCAL_GROUP=${LOCAL_GROUP}
# local environment
LOGROTATE_CFG=${DIR_ROOT}/deploy/bin/backup/media/logrotate.conf
```


## Perform processing

Useful activity is performed in this section.



## Finalize job

```bash
echo ""
echo "************************************************************************"
echo "  The job is done."
echo "************************************************************************"
cd ${DIR_CUR}
```