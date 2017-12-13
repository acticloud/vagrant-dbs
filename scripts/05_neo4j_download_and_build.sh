#!/usr/bin/env bash

BASE_DIR="/opt/neo4j"

mkdir -p ${BASE_DIR}
initpwd=$PWD
cd ${BASE_DIR}

wget https://s3-eu-west-1.amazonaws.com/quality.neotechnology.com/ldbc/acticloud/acticloud_ldbc_neo4j.tar.gz
tar xvfz acticloud_ldbc_neo4j.tar.gz

cd ${initpwd}
