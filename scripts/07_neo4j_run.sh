#!/usr/bin/env bash

BASE_DIR="/opt/neo4j"

initpwd=$PWD
cd ${BASE_DIR}

echo "Spawning Neo4J database server..."
./neo4j-enterprise-3.3.0/bin/neo4j start
echo "Sleeping for 10 seconds to allow the server to come up..."
sleep 10
echo "Done spawning Neo4J database server..."

echo "Executing benchmark..."
java -jar ldbc.jar run --ldbc-config ldbc_snb_interactive_SF-0001-read-cypher.properties
echo "Done executing benchmark"

cd ${initpwd}
