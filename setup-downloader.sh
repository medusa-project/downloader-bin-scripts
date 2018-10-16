#!/bin/bash

#This is to set up the things the local user can install, like
#getting source packages, rbenv, etc.

source $HOME/bin/set-vars.sh

function die {
    echo $1
    exit 1
}

#Get nginx stuff - nginx itself, mod_zip, nginx-http-auth-digest
mkdir -p $SRC_DIR
cd $SRC_DIR
if [ ! -f $NGINX_TARBALL ]; then
    echo "Getting nginx source"
    wget "$NGINX_TARBALL_URL" || die "Unable to download nginx"
    tar xvf $NGINX_TARBALL
    ln -nfs nginx-$NGINX_VERSION nginx
fi
cd $SRC_DIR
if [ ! -d mod_zip ]; then
    echo "Getting mod_zip source"
    git clone $MOD_ZIP_REPO_URL || die "Unable to clone mod_zip"
fi
cd $SRC_DIR
if [ ! -d nginx-http-auth-digest ]; then
    echo "Getting nginx-http-auth-digest source"
    git clone $NGINX_HTTP_AUTH_DIGEST_REPO_URL || die "Unable to clone http-auth-digest"
fi

if [ ! -d $NGINX_TARGET_DIR ] || [ ! -d $NGINX2_TARGET_DIR ]; then
    echo "Trying to build nginx"
    $HOME/bin/build-nginx.sh || die "Unable to build nginx"
    echo
    sleep 2
fi

if [ ! -d $NGINX_STORAGE_DIR ]; then
    mkdir -p $NGINX_STORAGE_DIR
    ln -nfs $NGINX_STORAGE_DIR $NGINX2_TARGET_DIR/html/internal
fi

##Set up rbenv and install ruby
if [ ! -d ~/.rbenv ]; then
    #get rbenv with plugins
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    ~/.rbenv/bin/rbenv init
    mkdir -p "$(rbenv root)"/plugins
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
    git clone https://github.com/rkh/rbenv-update.git "$(rbenv root)/plugins/rbenv-update"
    git clone https://github.com/rbenv/rbenv-vars.git "$(rbenv root)/plugins/rbenv-vars"
    git clone https://github.com/rbenv/rbenv-default-gems.git "$(rbenv root)/plugins/rbenv-default-gems"
    if [ ! -f $(rbenv root)/default-gems ]; then
	echo "bundler" > $(rbenv root)/default-gems
	echo "liquid" >> $(rbenv root)/default-gems
    fi
else
    rbenv update
fi

#make sure appropriate ruby version is installed, along with bundler at least
#We get the downloader source to get the version
cd $SRC_DIR
if [ ! -d medusa-downloader ]; then
    echo "Getting medusa downloader source"
    git clone "$DOWNLOADER_REPO_URL" || die "Unable to clone medusa downloader"
else
    cd $SRC_DIR/medusa-downloader
    git pull
fi
RUBY_VERSION="$(cat $SRC_DIR/medusa-downloader/.ruby-version)"
echo "Installing ruby version $RUBY_VERSION and making it the rbenv default"
eval "$(rbenv init -)"
rbenv install -s $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv shell $RUBY_VERSION

##Install any missing conf files - crontab, logrotate, nginx, nginx2, monit - this will
##be with templates and running some ruby
echo "Installing config files - copies will be in $HOME/bin/etc."
cd $HOME/bin
ruby setup-config.rb
cd $HOME/bin/etc
cp monitrc ~/.monitrc
echo "Installed .monitrc"
mkdir -p $HOME/etc
cp logrotate.conf $HOME/etc/logrotate.conf
echo "Installed logrotate.conf"
cp nginx.conf $NGINX_TARGET_DIR/conf/nginx.conf
echo "Installed nginx conf"
cp nginx2.conf $NGINX2_TARGET_DIR/conf/nginx.conf
echo "Installed ngins2 conf"
crontab crontab
echo "Installed crontab"

##Check for presence of digest_users html access file in nginx and alert if not present
if [ ! -f $NGINX_DIGEST_USERS_FILE ]; then
    echo "The digest users file $NGINX_DIGEST_USERS_FILE does not exists."
    echo "It will need to be created and maintained with htaccess"
    sleep 5
fi




