#!/usr/bin/env bash

mkdir -p /opt/maxineVM
cd /opt/maxineVM
git clone https://github.com/beehive-lab/Maxine-Graal.git graal
git clone https://github.com/beehive-lab/Maxine-VM.git maxine
cd maxine
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export MAXINE_HOME=$(pwd)
export DEFAULT_VM=maxine
export PATH=../graal/mxtool:$PATH
mx build
mx image
chown -R ubuntu:ubuntu /opt/maxineVM
