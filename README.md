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

