# ./bin/app/mage.sh

Install Magento 2 application itself.



## (Re)create web's root folder

```bash
if [ -d "${DIR_MAGE}" ]; then
    if [ "${MODE}" = "${MODE_WORK}" ]; then
        echo "Re-create '${DIR_MAGE}' folder."
        rm -fr ${DIR_MAGE}    # remove Magento root folder
        mkdir -p ${DIR_MAGE}  # ... then create it
    fi
else
    mkdir -p ${DIR_MAGE}      # just create folder if not exist
fi
echo "Magento will be installed into the '${DIR_MAGE}' folder."
```


## Create Magento 2 project with Composer

```bash
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition ${DIR_MAGE}
```