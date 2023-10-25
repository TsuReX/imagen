#!/bin/bash

# Debugging options
# This command is used to print each being executed line of script
#set -x
# This command is used to stop script execution after a command finished with non zero value
#set -e

PARAM_PATH_IDBLOCK=""
PARAM_PATH_UBOOT=""
PARAM_PATH_UBOOT_ENV_TXT=""
PARAM_PATH_LINUX_KERNEL=""
PARAM_PATH_DTB=""
PARAM_PATH_BUSYBOX_ROOTFS=""
PARAM_PATH_EXTERNAL_ROOTFS=""
PARAM_PATH_OVERLAY=""
PARAM_PATH_LINUX_MODULES=""
PARAM_PATH_UBOOTTOOLS=""
PARAM_PATH_GENIMAGE=""
PARAM_PATH_GENIMAGE_CFG=""

##CFG READING BLOCK
##**************************************************************************

DISTR_CFG=${1}

if ! [ -e ${DISTR_CFG} ]; then
	echo "File doesn't exist: ${DISTR_CFG}"
	exit -1
fi

while read -r cmd; do
    value=($cmd)
 #   echo -e "NAME: ${value[0]}\nVALUE: ${value[1]}"
    
	case ${value[0]} in

	"PARAM_PATH_IDBLOCK")
		PARAM_PATH_IDBLOCK=${value[1]}
		;;

	"PARAM_PATH_UBOOT")
		PARAM_PATH_UBOOT=${value[1]}
		;;

	"PARAM_PATH_UBOOT_ENV_TXT")
		PARAM_PATH_UBOOT_ENV_TXT=${value[1]}
		;;

	"PARAM_PATH_LINUX_KERNEL")
		PARAM_PATH_LINUX_KERNEL=${value[1]}
		;;

	"PARAM_PATH_DTB")
		PARAM_PATH_DTB=${value[1]}
		;;

	"PARAM_PATH_BUSYBOX_ROOTFS")
		PARAM_PATH_BUSYBOX_ROOTFS=${value[1]}
		;;

	"PARAM_PATH_EXTERNAL_ROOTFS")
		PARAM_PATH_EXTERNAL_ROOTFS=${value[1]}
		;;

	"PARAM_PATH_OVERLAY")
		PARAM_PATH_OVERLAY=${value[1]}
		;;

	"PARAM_PATH_LINUX_MODULES")
		PARAM_PATH_LINUX_MODULES=${value[1]}
		;;

	"PARAM_PATH_UBOOTTOOLS")
		PARAM_PATH_UBOOTTOOLS=${value[1]}
		;;

	"PARAM_PATH_GENIMAGE")
		PARAM_PATH_GENIMAGE=${value[1]}
		;;

	"PARAM_PATH_GENIMAGE_CFG")
		PARAM_PATH_GENIMAGE_CFG=${value[1]}
		;;

	*)
		echo "Unknown parameter: ${value[0]}"
		;;
	esac

   # printf '%s\n' "$cmd"
done < ${DISTR_CFG}

echo "PARAM_PATH_IDBLOCK: ${PARAM_PATH_IDBLOCK}"
echo "PARAM_PATH_UBOOT: ${PARAM_PATH_UBOOT}"
echo "PARAM_PATH_UBOOT_ENV_TXT: ${PARAM_PATH_UBOOT_ENV_TXT}"
echo "PARAM_PATH_LINUX_KERNEL: ${PARAM_PATH_LINUX_KERNEL}"
echo "PARAM_PATH_DTB: ${PARAM_PATH_DTB}"
echo "PARAM_PATH_BUSYBOX_ROOTFS: ${PARAM_PATH_BUSYBOX_ROOTFS}"
echo "PARAM_PATH_EXTERNAL_ROOTFS: ${PARAM_PATH_EXTERNAL_ROOTFS}"
echo "PARAM_PATH_OVERLAY: ${PARAM_PATH_OVERLAY}"
echo "PARAM_PATH_LINUX_MODULES: ${PARAM_PATH_LINUX_MODULES}"
echo "PARAM_PATH_UBOOTTOOLS: ${PARAM_PATH_UBOOTTOOLS}"
echo "PARAM_PATH_GENIMAGE_CFG: ${PARAM_PATH_GENIMAGE_CFG}"
echo "PARAM_PATH_GENIMAGE: ${PARAM_PATH_GENIMAGE}"

# 1. Check presence of all required files and utilities
#	idblock,
#	uboot,
#	uboot.env.txt,
#	mkenvimage,
#	linux,
#	path_to_linux_modules,
#	dtb,
#	busybox.rootfs,
#	external.rootfs,
#	distr_image.cfg
#	overlay

##CHECKING BLOCK
##**************************************************************************
if ! [ -e ${PARAM_PATH_IDBLOCK} ]; then
	echo "File doesn't exist: ${PARAM_PATH_IDBLOCK}"
	exit -1
fi


##**************************************************************************
WORKING_DIR=`echo ${DISTR_CFG} | cut -d"." -f1`"_tmp"
rm -rf ${WORKING_DIR}
mkdir ${WORKING_DIR}
cd ${WORKING_DIR}

cp ${PARAM_PATH_IDBLOCK}				idblock
cp ${PARAM_PATH_UBOOT}					uboot
cp ${PARAM_PATH_DTB}					dtb
cp ${PARAM_PATH_LINUX_KERNEL}			linux
#cp ${PARAM_PATH_BUSYBOX_ROOTFS}		busybox.rootfs.cpio.gz
cp ${PARAM_PATH_EXTERNAL_ROOTFS}		external.rootfs.ext4

${PARAM_PATH_UBOOTTOOLS}/mkimage -A arm -T ramdisk -C gzip -d ${PARAM_PATH_BUSYBOX_ROOTFS} busybox.rootfs.cpio.gz
${PARAM_PATH_UBOOTTOOLS}/mkenvimage -s 0x8000 -o uboot.env ${PARAM_PATH_UBOOT_ENV_TXT}

mountpoint mnt -q
if [ $? == 0 ]; then
	sudo umount mnt
fi
sudo rm -rf mnt

mkdir mnt
sudo mount ./external.rootfs.ext4 mnt
if ! [ $? == 0 ]; then
	exit -3
fi

sudo cp -rfT ${PARAM_PATH_OVERLAY} mnt/

sudo cp -rf ${PARAM_PATH_LINUX_MODULES} mnt/lib/modules/

sudo umount mnt
sudo rm -rf mnt

ROOTPATH_TMP="$(mktemp -d)"

rm -rf ${GENIMAGE_TMP}
GENIMAGE_TMP="./genimage.tmp"
${PARAM_PATH_GENIMAGE} --rootpath ${ROOTPATH_TMP} --tmppath ${GENIMAGE_TMP} --inputpath . --outputpath . --config ${PARAM_PATH_GENIMAGE_CFG}
rm -rf ${GENIMAGE_TMP}

cd -

echo "sudo dd if=${WORKING_DIR}/usd.img of=/dev/sdX status=progress bs=1M"

lsblk

# 2. Create binary file uboot.env from uboot.env.txt
# 3. Create coppy of external rootfs if it is needed regarding execution arguments
# 4. Modify external rootfs
# 5. Create final image

