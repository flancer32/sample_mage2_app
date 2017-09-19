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
OPT_CLONE_DB="no"               # -D
OPT_CLONE_MEDIA="no"            # -M
OPT_DEPLOY=developer            # -r developer|production
OPT_MODE=work                   # -d work|live

# Available deployment modes
MODE_LIVE=live
MODE_WORK=work



## *************************************************************************
#   Parse input options
## *************************************************************************
while getopts "d:r:hSDM" OPTNAME
  do
    case "${OPTNAME}" in
      "d")
        OPT_MODE=${OPTARG}
        echo "Application deployment mode '${OPT_MODE}' is specified"
        ;;
      "r")
        OPT_DEPLOY=${OPTARG}
        echo "Magento deployment mode '${OPT_DEPLOY}' is specified"
        ;;
      "h")
        OPT_CLI_HELP="yes"
        ;;
      "S")
        OPT_SKIP_DB="yes"
        echo "Database initialization will be skipped (use Web UI to init DB)."
        ;;
      "D")
        OPT_CLONE_DB="yes"
        echo "Database cloning is requested."
        ;;
      "M")
        OPT_CLONE_MEDIA="yes"
        echo "Media cloning is requested."
        ;;
    esac
  done



## *************************************************************************
#   Print out help
## *************************************************************************
if [ "${OPT_CLI_HELP}" = "yes" ]
then
    echo "Magento2 application deployment script."
    echo ""
    echo "Usage: sh deploy.sh -d [work|live] -r [developer|production] -S -D -M"
    echo ""
    echo "Where:"
    echo "  -d: Web application deployment mode ([work|live], default: work);"
    echo "  -r: Magento 2 itself deployment mode ([developer|production], default: developer);"
    echo "  -S: Skip database initialization (Web UI should be used to init DB);"
    echo "  -D: Clone database from 'live' instance during deployment;"
    echo "  -M: Clone media files from 'live' instance during deployment;"
    echo "  -h: This output;"
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
echo ""
echo "*************************************************************************"
echo "Deploy application"
echo "*************************************************************************"
cd ${DIR_ROOT}
. ./deploy/bin/app.sh


echo ""
if [ "$OPT_CLONE_DB"!="yes" ]; then
    echo "Database cloning is skipped."
else
    echo "*************************************************************************"
    echo "Clone DB"
    echo "*************************************************************************"
    cd ${DIR_ROOT}
    . ./deploy/bin/clone/db/do.sh
fi


echo ""
if [ "$OPT_CLONE_MEDIA"!="yes" ]; then
    echo "Media cloning is skipped."
else
    echo "*************************************************************************"
    echo "Clone media"
    echo "*************************************************************************"
    cd ${DIR_ROOT}
    . ./deploy/bin/clone/media/do.sh
fi


echo ""
echo "*************************************************************************"
echo "Finalize job..."
echo "*************************************************************************"
cd ${DIR_ROOT}
. ./deploy/bin/final.sh

echo ""
echo "Application deployment in '${OPT_MODE}' mode  is done."
cd ${DIR_CUR}