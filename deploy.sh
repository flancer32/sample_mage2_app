#!/usr/bin/env bash
## *************************************************************************
#   Deployment script for Magento 2 based apps.
#
#       This is friendly user script, not user friendly
#       There are no protection from mistakes.
#       Use it if you know how it works.
## *************************************************************************

# pin current folder and deployment root folder
DIR_CUR="$PWD"
DIR_ROOT="$( cd "$( dirname "$0" )" && pwd )"

# default configuration
OPT_CLI_HELP="no"               # -h print out help
OPT_SKIP_DB="no"                # -S
OPT_USE_EXIST_DB="no"           # -E
OPT_CLONE_DB="no"               # -D
OPT_CLONE_MEDIA="no"            # -M
OPT_MAGE_RUN=developer          # -m developer|production
OPT_MODE=work                   # -d work|live

# Available deployment modes
MODE_LIVE=live
MODE_WORK=work



## *************************************************************************
#   Parse input options
## *************************************************************************
echo ""
while getopts "d:hm:DEMS" OPTNAME
  do
    case "${OPTNAME}" in
      "d")
        OPT_MODE=${OPTARG}
        echo "Application deployment mode '${OPT_MODE}' is specified."
        ;;
      "h")
        OPT_CLI_HELP="yes"
        ;;
      "m")
        OPT_MAGE_RUN=${OPTARG}
        echo "Magento deployment mode '${OPT_MAGE_RUN}' is specified."
        ;;
      "D")
        OPT_CLONE_DB="yes"
        echo "Database cloning is requested."
        ;;
      "E")
        OPT_USE_EXIST_DB="yes"
        echo "Existing DB will be used in 'work' mode."
        ;;
      "M")
        OPT_CLONE_MEDIA="yes"
        echo "Media cloning is requested."
        ;;
      "S")
        OPT_SKIP_DB="yes"
        echo "Database initialization will be skipped (use Web UI to create DB)."
        ;;
    esac
  done

echo""



## *************************************************************************
#   Print out help
## *************************************************************************
if [ "${OPT_CLI_HELP}" = "yes" ]; then
    echo "Magento2 application deployment script."
    echo ""
    echo "Usage: sh deploy.sh -d [work|live] -h -m [developer|production] -D -E -M -S"
    echo ""
    echo "Where:"
    echo "  -d: Web application deployment mode ([work|live], default: work);"
    echo "  -h: This output;"
    echo "  -m: Magento 2 itself deployment mode ([developer|production], default: developer);"
    echo "  -D: Clone database from 'live' instance during deployment;"
    echo "  -E: Existing DB will be used in 'work' mode);"
    echo "  -M: Clone media files from 'live' instance during deployment;"
    echo "  -S: Skip database initialization (Web UI should be used to init DB);"
    exit
fi



## *************************************************************************
#   Validate current deployment mode (work|live)
## *************************************************************************
MODE=${MODE_WORK}
case "${OPT_MODE}" in
    ${MODE_WORK}|${MODE_LIVE})
        MODE=${OPT_MODE};;
esac

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



## *************************************************************************
#   Deployment process itself
## *************************************************************************
cd ${DIR_ROOT}
. ./deploy/bin/app.sh


echo ""
if [ "$OPT_CLONE_DB"!="yes" ]; then
    echo "Database cloning is skipped."
else
    cd ${DIR_ROOT}
    . ./deploy/bin/clone/db/do.sh
fi


echo ""
if [ "$OPT_CLONE_MEDIA"!="yes" ]; then
    echo "Media cloning is skipped."
else
    cd ${DIR_ROOT}
    . ./deploy/bin/clone/media/do.sh
fi

echo ""
cd ${DIR_ROOT}
. ./deploy/bin/final.sh

echo ""
echo "Application deployment in '${OPT_MODE}' mode  is done."
echo "  Frontend: ${BASE_URL}"
echo "  Backend:  ${BASE_URL}/${BACKEND_FRONTNAME}"
echo ""
cd ${DIR_CUR}