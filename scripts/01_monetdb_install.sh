#!/bin/sh

apt-get update && apt-get upgrade -y && apt-get install -y wget

mkdir -p /root/monetdb
cd /root/monetdb

dlfile=acticloud_xenial_distribution_20171030
monet_distribution=11.27.9

wget https://www.monetdbsolutions.com/downloads/acticloud/${dlfile}.tar.bz2
tar xvf ${dlfile}.tar.bz2

apt-get install -y libcurl3-gnutls

cd ${dlfile}
dpkg -i libmonetdb-stream8_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i libmonetdb15_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i libmonetdb-client9_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i monetdb5-server_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i monetdb5-sql_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i monetdb5-server-hugeint_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i monetdb5-sql-hugeint_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i monetdb-client_${monet_distribution}_amd64.deb
apt-get -yf install
dpkg -i monetdb-client-tools_${monet_distribution}_amd64.deb
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

systemctl enable monetdbd
systemctl start monetdbd

usermod -aG monetdb ubuntu

cat << EOF > ~/.monetdb
user=monetdb
password=monetdb
save_history=true
EOF
