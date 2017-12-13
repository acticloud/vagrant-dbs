#!/usr/bin/env bash

BASE_DIR="/opt/monetdb"

apt-get install -y pkg-config python bison libssl-dev libxml2-dev

mkdir -p ${BASE_DIR}
initpwd=$PWD
cd ${BASE_DIR}

wget http://monetdbsolutions.com/downloads/acticloud/MonetDB_Jul2017_SP2_20171103.tar.bz2
tar xjfv MonetDB_Jul2017_SP2_20171103.tar.bz2
cd MonetDB-11.27.10/
mkdir build
cd build
../configure --prefix=$(pwd)/install --enable-optimize --disable-assert --disable-optimize --enable-testing
make -j install

cd ${initpwd}
