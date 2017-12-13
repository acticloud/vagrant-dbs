#!/usr/bin/env bash

BASE_DIR="/opt/monetdb-tpch"
MDB_PATH="/opt/monetdb/MonetDB-11.27.10/build/install/bin/"
SF="1"

export PATH=$MDB_PATH:$PATH

mkdir -p ${BASE_DIR}/scripts
mkdir -p ${BASE_DIR}/data
initpwd=$PWD
cd ${BASE_DIR}/scripts

git clone https://github.com/MonetDBSolutions/tpch-scripts ${BASE_DIR}/scripts

echo "Creating data for Scale Factor $SF..."
./tpch_build.sh --sf $SF --farm ${BASE_DIR}/data/farm
echo "Done building data"

echo "Spawning mserver..."
mserver5 --dbpath=${BASE_DIR}/data/farm/SF-1 --set monet_vault_key=${BASE_DIR}/data/farm/SF-1/.vaultkey --daemon=yes &> /dev/null &
echo "Sleeping for 10 seconds to allow the server to come up..."
sleep 10
echo "Done spawning mserver"

echo "Executing benchmark..."
cd ${BASE_DIR}/scripts/03_run
tag="acticloud-SF_${SF}-`date +"%Y_%m_%d-%H_%M"`"
./horizontal_run.sh -d SF-${SF} -t $tag
mv timings.csv results/$tag/
echo "Done executing benchmark"

cd ${initpwd}
