#!/bin/bash
# Fetch the corpus
set -e

##
# Pre-requirements:
# - env PUT: path to put work dir
##

cd $CORPUS
wget https://github.com/mozilla/pdf.js-sample-files/raw/master/helloworld.pdf
wget https://www.melbpc.org.au/wp-content/uploads/2017/10/small-example-pdf-file.pdf