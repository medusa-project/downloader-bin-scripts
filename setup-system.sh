#!/bin/bash

#This is to set up things like yum packages needed an so forth, so will
#need to be run with sudo

#install necessary os packages
#General
YUM_PACKAGES="emacs-nox gcc nodejs"
#nginx
YUM_PACKAGES="$YUM_PACKAGES pcre-devel zlib-devel"
#ruby
YUM_PACKAGES="$YUM_PACKAGES bzip2 openssl-devel readline-devel"
yum install $YUM_PACKAGES

#install yarn globally
npm install -g yarn
