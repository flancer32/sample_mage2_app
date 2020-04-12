# sample_mage2_app

## Description
This project contains shell scripts to deploy Magento 2 based apps. Scripts preform following actions:
* install Magento2 base with `composer`;
* create links to folders with media and logs (these are useful parts of app and should be re-linked on upgrades);
* setup `composer` to connect to external repos (repo.magento.com, GitHub repos, 3rd parties repos, etc.) ;
* create new DB (with `-n` option) and fill it with sample data (with `-i` option);
* add custom extensions to base Magento 2 app (define list of extensions in `bin/deploy/app/[work|live].sh`);
* patch core Magento files & custom extensions files;
* finalize deployment according to given mode: `work` (for development) or `live` (with static compilation, etc.)    

These actions are typical for deployment of Magento 2 based projects. 


## Usage

Run main script (`./bin/deploy/main.sh`):

    Deployment script for Magento2 based application.
    
    Usage: sh main.sh -d [work|live] -i -n
    
    Where:
      -d: Deployment mode ([work|live], default: work);
      -h: This output;
      -i: Fill Magento DB with demo data (includes '-n');
      -n: Re-create Magento DB;



## Deployment descriptor

Create deployment configuration (`cfg.[work|live].sh`) using [./cfg.init.sh](./cfg.init.sh) before deployment and set options for deployment configuration:

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
    export BASE_URL_SECURE="https://mage2.host.org:8080/" # set trailing '/'
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



## Apache simple configuration

```
<VirtualHost *:80>
        ServerName sample.domain.com
        ServerAdmin user@email.com
        DocumentRoot /.../sample_mage2_app/work/pub
        <Directory /.../sample_mage2_app/work/pub/>
                AllowOverride All
                Require all granted
        </Directory>
        LogLevel info
        ErrorLog ${APACHE_LOG_DIR}/sample_error.log
        CustomLog ${APACHE_LOG_DIR}/sample_access.log combined
</VirtualHost>
```
