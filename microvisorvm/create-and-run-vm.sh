#!/usr/bin/env bash

set -e

###################################
## General configuration options ##
###################################
OSD_EXE="/root/osd"
OSD_IMAGE_NAME="acticloud-img"
OSD_IMAGE_ARCH="arm64" # arm64 or x86_64
OSD_IMAGE_FILE="xenial-server-cloudimg-${OSD_IMAGE_ARCH}-disk1.img"
OSD_FLAVOR_NAME="acticloud-flavor"
OSD_FLAVOR_RAM="3000" # MB
OSD_FLAVOR_CPUS="4"
OSD_FLAVOR_DISK="10" # GB
OSD_NETWORK_NAME="acticloud-network"
OSD_NETWORK_IPSTART="112.121.12.1"
OSD_NETWORK_IPEND="112.121.12.200"
OSD_VM_NAME="acticloud-vm"
OSD_DATASTORE_ID="hs3f16yzwiq9mb" ## FIXME do we need to create this or leave this as is?
OSD_GROUP_ID="4" ## FIXME the same as above
###################################


######################
## Create the image ##
######################
echo "Creating image $OSD_IMAGE_NAME..."
nlines=`$OSD_EXE get_images | grep $OSD_IMAGE_NAME | wc -l`
if (( $nlines != 0 )); then
	img_id=`$OSD_EXE get_images | grep "name=${OSD_IMAGE_NAME}" -B 3 | grep "id=" | head -n 1 | cut -d'=' -f2`
	echo " [Already there, id=$img_id]"
else
	[ ! -f ${OSD_IMAGE_FILE} ] && wget "https://cloud-images.ubuntu.com/xenial/current/${OSD_IMAGE_FILE}"
	img_id=`$OSD_EXE create_image --name=$OSD_IMAGE_NAME --container_format=bare \
	                              --disk_format=qcow2 --distro=ubuntu --visibility=public \
	                              --arch=${OSD_IMAGE_ARCH} --version=16.04 --cluster_type=vm --filter=id | \
	                              grep "id=" | head -n1 | cut -d'=' -f2`
	$OSD_EXE update_image_file --id=$img_id --file=${OSD_IMAGE_FILE}
	echo " [OK: id = $img_id]"
fi
######################

#######################
## Create the flavor ##
#######################
echo "Creating flavor $OSD_FLAVOR_NAME..."
nlines=`$OSD_EXE get_flavors | grep $OSD_FLAVOR_NAME | wc -l`
if (( $nlines != 0 )); then
	flavor_id=`$OSD_EXE get_flavors | grep "name=${OSD_FLAVOR_NAME}" -B 1 | head -n 1 | cut -d'=' -f2`
	echo " [Already there, id=$flavor_id]"
else
	flavor_id=`$OSD_EXE create_flavor --name=$OSD_FLAVOR_NAME --ram=$OSD_FLAVOR_RAM \
	                                  --cpus=$OSD_FLAVOR_CPUS --disk=$OSD_FLAVOR_DISK | \
	                              grep "id=" | head -n 1 | cut -d'=' -f2`
	echo " [OK: id = $flavor_id]"
fi
######################


########################
## Create the network ##
#####################3##
echo "Creating network $OSD_NETWORK_NAME..."
nlines=`$OSD_EXE get_networks | grep $OSD_NETWORK_NAME | wc -l`
if (( $nlines != 0 )); then
	network_id=`$OSD_EXE get_networks | grep "name="${OSD_NETWORK_NAME} -B 6 | grep "id=" | head -n 1 | cut -d'=' -f2`
	echo " [Already there, id=$network_id]"
else
	network_id=`$OSD_EXE create_network --name=$OSD_NETWORK_NAME \
	                                    --ip_start=$OSD_NETWORK_IPSTART --ip_end=$OSD_NETWORK_IPEND | \
	                              grep "id=" | head -n 1 | cut -d'=' -f2`
	echo " [OK: id = $network_id]"
fi
######################


##################
## Spawn the VM ##
##################
echo -n "Spawning image ..."
$OSD_EXE create_instance --name=$OSD_VM_NAME \
                         --image_id=$img_id \
                         --flavor_id=$flavor_id \
                         --network_ids=$network_id \
                         --group_id=${OSD_GROUP_ID} \
                         --datastores=${OSD_DATASTORE_ID} \
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
