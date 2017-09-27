# sample_mage2_app

Demo deployment of the Magento 2 based apps.

    Magento2 application deployment script.
    
    Usage: sh deploy.sh -d [work|live] -h -m [developer|production] -D -E -M -S
    
    Where:
      -d: Web application deployment mode ([work|live], default: work);
      -h: This output;
      -m: Magento 2 itself deployment mode ([developer|production], default: developer);
      -D: Clone database from 'live' instance during deployment;
      -E: Existing DB will be used in 'work' mode);
      -M: Clone media files from 'live' instance during deployment;
      -S: Skip database initialization (Web UI should be used to init DB);


Create deployment configuration (`cfg.work.sh`) using [cfg.init.sh](./cfg.init.sh) before deployment:

    #!/usr/bin/env bash
    
    # filesystem permissions
    LOCAL_OWNER="owner"
    LOCAL_GROUP="www-data"
    
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

`live` mode is not allowed yet.