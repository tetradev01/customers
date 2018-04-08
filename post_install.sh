#!/usr/bin/env bash
set -e

cd ~/customers
npm install

cd ~/customers/sqls/bundle
sudo -u postgres -H sh -c 'createdb nodejs;'
echo 'Database created.'


# setup NODE_ENV
if [ ! -z "$DEPLOYMENT_GROUP_NAME" ]; then
    export NODE_ENV=$DEPLOYMENT_GROUP_NAME

    hasEnv=`grep "export NODE_ENV" ~/.bash_profile | cat`
    if [ -z "$hasEnv" ]; then
        echo "export NODE_ENV=$DEPLOYMENT_GROUP_NAME" >> ~/.bash_profile
    else
        sed -i "/export NODE_ENV=\b/c\export NODE_ENV=$DEPLOYMENT_GROUP_NAME" ~/.bash_profile
    fi
fi

# add node to startup
hasRc=`grep "su -l $USER" /etc/rc.d/rc.local | cat`
if [ -z "$hasRc" ]; then
    sudo sh -c "echo 'su -l $USER -c \"cd ~/customers;sh ./run.sh\"' >> /etc/rc.d/rc.local"
fi
