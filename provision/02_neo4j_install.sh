#!/usr/bin/env bash

wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list
apt-get update && apt-get -y install neo4j
mkdir -p /var/run/neo4j/
sed -i 's/#dbms.connectors.default_listen_address=0.0.0.0/dbms.connectors.default_listen_address=0.0.0.0/' /etc/neo4j/neo4j.conf
neo4j start
