#!/usr/bin/env bash

set -e

###################################
## General configuration options ##
###################################
XENBRIDGE="virbr0"
VMIP=""
VMNAME="acticloud-dbs"
VMMEM="2gb"
VMVCPUS="2"
VMROOTPASS="acticloud"
###################################


######################
## Create the image ##
######################
echo "Creating image ..."
xen-create-image --hostname=${VMNAME} --memory=${VMMEM} --vcpus=${VMVCPUS} \
                 --bridge=${XENBRIDGE} \
                 --password=${VMROOTPASS} \
                 --dhcp --pygrub --noswap --dist=xenial
(( $? != 0 )) && echo "ERROR creating the image of the VM." && exit 1
######################


#####################
## Spawn the image ##
#####################
echo "Spawning image ..."
xl create /etc/xen/${VMNAME}.cfg
if (( $? != 0 )); then
  echo "ERROR spawning the image of the VM."
  exit 1
fi
#####################


##########################################################
## Print info on how to connect to the newly created VM ##
##########################################################
echo "To connect to the VM do the following:"
echo "$ xl console ${VMNAME}"
echo " and login as root with pass ${VMROOTPASS}"
##########################################################
