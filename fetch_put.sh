#!/bin/bash
# Fetch the source of the PUT
set -e

cd $PUT
mkdir src
cd src

wget https://dl.xpdfreader.com/old/xpdf-3.02.tar.gz
tar -xvzf xpdf-3.02.tar.gz
cd xpdf-3.02