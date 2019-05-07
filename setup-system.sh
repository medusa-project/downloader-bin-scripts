#!/bin/bash

#This is to set up things like yum packages needed an so forth, so will
#need to be run with sudo

#install necessary os packages
#General
YUM_PACKAGES="emacs-nox gcc nodejs monit"
#nginx
YUM_PACKAGES="$YUM_PACKAGES pcre-devel zlib-devel"
#ruby
YUM_PACKAGES="$YUM_PACKAGES bzip2 openssl-devel readline-devel"
#needed to get htdigest program
YUM_PACKAGES="$YUM_PACKAGES httpd-tools"
#needed for rails app
YUM_PACKAGES="$YUM_PACKAGES libcurl-devel postgresql-devel gcc-c++"
#needed for clojure-zipper
YUM_PACKAGES="$YUM_PACKAGES java-1.8.0-openjdk"
yum --assumeyes install $YUM_PACKAGES

#I didn't get the necessary g++ until I installed this
yum --assumeyes groupinstall 'Development Tools'

#install yarn globally
npm install -g yarn

#install rclone
curl https://rclone.org/install.sh | bash

#install leiningen for clojure-zipper
curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > /usr/local/bin/lein
chmod 755 /usr/local/bin/lein
