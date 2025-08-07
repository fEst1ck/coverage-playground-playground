#!/bin/bash
set -e

cd $PUT/src/xpdf-3.02

export CC="$FUZZER/path-clang"
export CXX="$FUZZER/path-clang++"
export COVERAGE_DIR="$PUT/coverage"

./configure --prefix="$PUT/install/"
make
make install

cp $PUT/install/bin/pdftotext $OUT/pdftotext