#!/bin/bash
set -e

cd $HOME
mkdir fuzzing_xpdf && cd fuzzing_xpdf/
wget https://dl.xpdfreader.com/old/xpdf-3.02.tar.gz
tar -xvzf xpdf-3.02.tar.gz
cd xpdf-3.02

export CC="$FUZZER/path-clang"
export CXX="$FUZZER/path-clang++"
export COVERAGE_DIR="$FUZZER/coverage"

export CFLAGS="$CFLAGS -fsanitize=fuzzer-no-link"
export CXXFLAGS="$CXXFLAGS -fsanitize=fuzzer-no-link -stdlib=libstdc++"
export LDFLAGS="$LDFLAGS -fsanitize=fuzzer-no-link -stdlib=libstdc++ -L$OUT"

export LIBS="$LIBS $FUZZER/libStandaloneFuzzTarget.a -lstdc++"

./configure --prefix="$HOME/fuzzing_xpdf/install/"
make
make install

cd $HOME/fuzzing_xpdf
mkdir pdf_examples && cd pdf_examples
wget https://github.com/mozilla/pdf.js-sample-files/raw/master/helloworld.pdf
wget http://www.africau.edu/images/default/sample.pdf
wget https://www.melbpc.org.au/wp-content/uploads/2017/10/small-example-pdf-file.pdf