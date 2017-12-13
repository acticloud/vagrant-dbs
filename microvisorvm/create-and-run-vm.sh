#!/usr/bin/env bash

set -e

###################################
## General configuration options ##
###################################
OSD_EXE="/root/osd"
OSD_IMAGE_NAME="acticloud-img"
OSD_FLAVOR_NAME="acticloud-flavor"
OSD_FLAVOR_RAM="8gb"
OSD_FLAVOR_CPUS="4"
OSD_FLAVOR_DISK="10"
OSD_NETWORK_NAME="acticloud-network"
OSD_NETWORK_IPSTART="112.121.12.1"
OSD_NETWORK_IPEND="112.121.12.200"
OSD_VM_NAME="acticloud-vm"
###################################


######################
## Create the image ##
######################
echo "Creating image $OSD_IMAGE_NAME..."
nlines=`$OSD_EXE get_images | grep $OSD_IMAGE_NAME | wc -l`
if (( $nlines != 0 )); then
	echo " [Already there]"
	img_id=`$OSD_EXE get_images | grep "id=" | cut -d'=' -f2` # FIXME
else
	wget "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img"
	img_id=`$OSD_EXE create_image --name=$OSD_IMAGE_NAME --container_format=bare \
	                              --disk_format=qcow2 --distro=ubuntu --visibility=public \
	                              --arch=x86_64 --version=16.04 --cluster_type=vm --filter=id | \
	                              grep "id=" | cut -d'=' -f2`
	$OSD_EXE update_image_file --id=$img_id --file=xenial-server-cloudimg-amd64-disk1.img
	echo " [OK: id = $img_id]"
fi
######################


#######################
## Create the flavor ##
#######################
echo "Creating flavor $OSD_FLAVOR_NAME..."
nlines=`$OSD_EXE get_flavors | grep $OSD_FLAVOR_NAME | wc -l`
if (( $nlines != 0 )); then
	echo " [Already there]"
	flavor_id=`$OSD_EXE get_flavors | grep "id=" | cut -d'=' -f2` # FIXME
else
	flavor_id=`$OSD_EXE create_flavor --name=$OSD_FLAVOR_NAME --ram=$OSD_FLAVOR_RAM \
	                                  --cpus=$OSD_FLAVOR_DISK --disk=$OSD_FLAVOR_DISK | \
	                              grep "id=" | cut -d'=' -f2`
	echo " [OK: id = $flavor_id]"
fi
######################


########################
## Create the network ##
#####################3##
echo "Creating network $OSD_NETWORK_NAME..."
nlines=`$OSD_EXE get_networks | grep $OSD_NETWORK_NAME | wc -l`
if (( $nlines != 0 )); then
	echo " [Already there]"
	network_id=`$OSD_EXE get_networks | grep "id=" | cut -d'=' -f2` # FIXME
else
	network_id=`$OSD_EXE create_network --name=$OSD_NETWORK_NAME \
	                                    --ip_start=$OSD_NETWORK_IPSTART --ip_end=$OSD_NETWORK_IPEND | \
	                              grep "id=" | cut -d'=' -f2`
	echo " [OK: id = $network_id]"
fi
######################


##################
## Spawn the VM ##
##################
echo -n "Spawning image ..."
$OSD_EXE create_instance --name=$OSD_VM_NAME \
                         --flavor_id=$flavor_id --image_id=$img_id \
                         --network_ids=$network_id \
                         --group_id=FIXME --datastores=FIXME \
                         --filter=id,result
echo " [OK]"
#####################


##########################################################
## Print info on how to connect to the newly created VM ##
##########################################################
#echo "To connect to the VM do the following:"
#echo "$ xl console ${VMNAME}"
#echo " and login as root with pass ${VMROOTPASS}"
##########################################################
