#!/bin/sh

apt-get update && apt-get upgrade -y && apt-get install -y wget

mkdir -p /root/monetdb
cd /root/monetdb

wget https://www.monetdbsolutions.com/downloads/acticloud/acticloud_xenial_distribution_20171002.tar.bz2
tar xvf acticloud_xenial_distribution_20171002.tar.bz2

apt-get install -y libcurl3-gnutls

cd acticloud_xenial_distribution_20171002
dpkg -i libmonetdb-stream8_11.27.5_amd64.deb
apt-get -yf install
dpkg -i libmonetdb15_11.27.5_amd64.deb
apt-get -yf install
dpkg -i libmonetdb-client9_11.27.5_amd64.deb
apt-get -yf install
dpkg -i monetdb5-server_11.27.5_amd64.deb
apt-get -yf install
dpkg -i monetdb5-sql_11.27.5_amd64.deb
apt-get -yf install
dpkg -i monetdb5-sql-hugeint_11.27.5_amd64.deb
apt-get -yf install
dpkg -i monetdb-client_11.27.5_amd64.deb
apt-get -yf install

cat << EOF > /etc/default/monetdb5-sql
# Defaults for monetdb5-sql initscript
# sourced by /etc/init.d/monetdb5-sql
# installed at /etc/default/monetdb5-sql by the maintainer scripts

# should monetdbd be started at system startup (yes/no)
STARTUP="yes"

# the database farm where databases are kept
DBFARM=/var/lib/monetdb
EOF

systemctl enable monetdb5-sql
systemctl start monetdb5-sql

cat << EOF > ~/.monetdb
user=monetdb
password=monetdb
save_history=true
