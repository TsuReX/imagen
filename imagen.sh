#!/bin/bash

# Debugging options
# This command is used to print each being executed line of script
#set -x
# This command is used to stop script execution after a command finished with non zero value
#set -e

TASK=""
CONFIGURATION=""
DESTINATION=""

PARAM_PATH_IDBLOCK=""
PARAM_PATH_UBOOT=""
PARAM_PATH_UBOOT_ENV_TXT=""
PARAM_PATH_LINUX_KERNEL=""
PARAM_PATH_DTB=""
PARAM_PATH_BUSYBOX_ROOTFS=""
PARAM_PATH_EXTERNAL_ROOTFS=""
PARAM_PATH_OVERLAY=""
PARAM_PATH_LINUX_MODULES=""
PARAM_PATH_GENIMAGE_CFG=""

IDBLOCK="idblock"
UBOOT="uboot"
DTB="dtb"
LINUX="linux"
BUSYBOX_ROOTFS="busybox.rootfs.cpio.gz"
EXTERNAL_ROOTFS="external.rootfs.ext4"
UBOOT_ENV="uboot.env"

read_configuration() {
	while read -r cmd; do
		value=($cmd)
	#   echo -e "NAME: ${value[0]}\nVALUE: ${value[1]}"
		
		case ${value[0]} in

		"PARAM_PATH_IDBLOCK")
#		${parameter:=word}
#		If parameter is unset or null, the expansion of word is assigned to parameter. 
#		The value of parameter is then substituted.
#		Positional parameters and special parameters may not be assigned to in this way.
			VAR=${value[1]}
			: ${PARAM_PATH_IDBLOCK:=$VAR}
			;;

		"PARAM_PATH_UBOOT")
			VAR=${value[1]}
			: ${PARAM_PATH_UBOOT:=$VAR}
			;;

		"PARAM_PATH_UBOOT_ENV_TXT")
			VAR=${value[1]}
			: ${PARAM_PATH_UBOOT_ENV_TXT:=$VAR}
			;;

		"PARAM_PATH_LINUX_KERNEL")
			VAR=${value[1]}
			: ${PARAM_PATH_LINUX_KERNEL:=$VAR}
			;;

		"PARAM_PATH_DTB")
			VAR=${value[1]}
			: ${PARAM_PATH_DTB:=$VAR}
			;;

		"PARAM_PATH_BUSYBOX_ROOTFS")
			VAR=${value[1]}
			: ${PARAM_PATH_BUSYBOX_ROOTFS:=$VAR}
			;;

		"PARAM_PATH_EXTERNAL_ROOTFS")
			VAR=${value[1]}
			: ${PARAM_PATH_EXTERNAL_ROOTFS:=$VAR}
			;;

		"PARAM_PATH_OVERLAY")
			VAR=${value[1]}
			: ${PARAM_PATH_OVERLAY:=$VAR}
			;;

		"PARAM_PATH_LINUX_MODULES")
			VAR=${value[1]}
			: ${PARAM_PATH_LINUX_MODULES:=$VAR}
			;;

		"PARAM_PATH_GENIMAGE_CFG")
			VAR=${value[1]}
			: ${PARAM_PATH_GENIMAGE_CFG:=$VAR}
			;;

		*)
			echo "Unknown parameter: ${value[0]}"
			;;
		esac

	done < ${CONFIGURATION}
}

fill_with_data() {

	if [ ${PARAM_PATH_IDBLOCK} ]; then
		echo "****************"
		echo "Updating IDBLOCK"

		if ! [ -f ${PARAM_PATH_IDBLOCK} ]; then
			echo "File doesn't exist: ${PARAM_PATH_IDBLOCK}"
			exit -1
		fi

		sudo dd if=${PARAM_PATH_IDBLOCK} of=${DESTINATION} bs=1K seek=32 conv=notrunc 2>/dev/null
		if ! [ $? == 0 ]; then
			echo "IDBLOCK can't be updated"
			exit -1
		fi
#ls -lh ${DESTINATION}
#fdisk -lu ${DESTINATION}
	fi

	if [ ${PARAM_PATH_UBOOT} ]; then
		echo "****************"
		echo "Updating UBOOT"

		if ! [ -f ${PARAM_PATH_UBOOT} ]; then
			echo "File doesn't exist: ${PARAM_PATH_UBOOT}"
			exit -1
		fi

		sudo dd if=${PARAM_PATH_UBOOT} of=${DESTINATION} bs=1M seek=8 conv=notrunc 2>/dev/null
		if ! [ $? == 0 ]; then
			echo "UBOOT can't be updated"
			exit -1
		fi
#ls -lh ${DESTINATION}
#fdisk -lu ${DESTINATION}
	fi

	if [ ${PARAM_PATH_UBOOT_ENV_TXT} ]; then
		echo "****************"
		echo "Updating UBOOT_ENV_TXT"

		if ! [ -f ${PARAM_PATH_UBOOT_ENV_TXT} ]; then
			echo "File doesn't exist: ${PARAM_PATH_UBOOT_ENV_TXT}"
			exit -1
		fi

		if  [ -f ${DESTINATION} ]; then
			sudo mount -o loop,offset=16777216 -t auto ${DESTINATION} ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		elif [ -b ${DESTINATION} ]; then
			sudo mount -t auto ${DESTINATION}1 ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		fi

		sudo mkenvimage -s 0x8000 -o ${WORKING_DIR}/mnt/part0/${UBOOT_ENV} ${PARAM_PATH_UBOOT_ENV_TXT}
		if ! [ $? == 0 ]; then
			echo "UBOOT_ENV_TXT can't be updated"
			exit -1
		fi

		sudo umount -l ${WORKING_DIR}/mnt/part0
	fi

	if [ ${PARAM_PATH_LINUX_KERNEL} ]; then
		echo "****************"
		echo "Updating LINUX_KERNEL"
		if ! [ -f ${PARAM_PATH_LINUX_KERNEL} ]; then
			echo "File doesn't exist: ${PARAM_PATH_LINUX_KERNEL}"
			exit -1
		fi

		if  [ -f ${DESTINATION} ]; then
			sudo mount -o loop,offset=16777216 -t auto ${DESTINATION} ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		elif [ -b ${DESTINATION} ]; then
			sudo mount -t auto ${DESTINATION}1 ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		fi

		sudo cp -f ${PARAM_PATH_LINUX_KERNEL} ${WORKING_DIR}/mnt/part0/${LINUX}
		if ! [ $? == 0 ]; then
			echo "LINUX_KERNEL can't be updated"
			exit -1
		fi

		sudo umount -l ${WORKING_DIR}/mnt/part0
	fi

	if [ ${PARAM_PATH_DTB} ]; then
		echo "****************"
		echo "Updating DTB"

		if ! [ -f ${PARAM_PATH_DTB} ]; then
			echo "File doesn't exist: ${PARAM_PATH_DTB}"
			exit -1
		fi

		if  [ -f ${DESTINATION} ]; then
			sudo mount -o loop,offset=16777216 -t auto ${DESTINATION} ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		elif [ -b ${DESTINATION} ]; then
			sudo mount -t auto ${DESTINATION}1 ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		fi

		sudo cp -f ${PARAM_PATH_DTB} ${WORKING_DIR}/mnt/part0/${DTB}
		if ! [ $? == 0 ]; then
			echo "DTB can't be updated"
			exit -1
		fi

		sudo umount -l ${WORKING_DIR}/mnt/part0
	fi

	if [ ${PARAM_PATH_BUSYBOX_ROOTFS} ]; then
		echo "****************"
		echo "Updating BUSYBOX_ROOTFS"

		if ! [ -f ${PARAM_PATH_BUSYBOX_ROOTFS} ]; then
			echo "File doesn't exist: ${PARAM_PATH_BUSYBOX_ROOTFS}"
			exit -1
		fi

		if  [ -f ${DESTINATION} ]; then
			sudo mount -o loop,offset=16777216 -t auto ${DESTINATION} ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		elif [ -b ${DESTINATION} ]; then
			sudo mount -t auto ${DESTINATION}1 ${WORKING_DIR}/mnt/part0
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part0"
				exit -1
			fi
		fi

		sudo rm -rf ${WORKING_DIR}/mnt/part0/${BUSYBOX_ROOTFS}

		sudo mkimage -A arm -T ramdisk -C gzip -d ${PARAM_PATH_BUSYBOX_ROOTFS} ${WORKING_DIR}/mnt/part0/${BUSYBOX_ROOTFS} 1>/dev/null 2>/dev/null
		if ! [ $? == 0 ]; then
			echo "BUSYBOX_ROOTFS can't be updated"
			exit -1
		fi

		sudo umount -l ${WORKING_DIR}/mnt/part0
	fi

	if [ ${PARAM_PATH_EXTERNAL_ROOTFS} ]; then
		echo "****************"
		echo "Updating EXTERNAL_ROOTFS"

		if ! [ -f ${PARAM_PATH_EXTERNAL_ROOTFS} ]; then
			echo "File doesn't exist: ${PARAM_PATH_EXTERNAL_ROOTFS}"
			exit -1
		fi

		sudo dd if=${PARAM_PATH_EXTERNAL_ROOTFS} of=${DESTINATION} bs=1M seek=528 conv=notrunc 2>/dev/null
		sync
		if ! [ $? == 0 ]; then
			echo "EXTERNAL_ROOTFS can't be updated"
			exit -1
		fi
	fi

	if [ ${PARAM_PATH_OVERLAY} ]; then
		echo "****************"
		echo "Updating OVERLAY"

		if ! [ -d ${PARAM_PATH_OVERLAY} ]; then
			echo "Directory doesn't exist: ${PARAM_PATH_OVERLAY}"
			exit -1
		fi

		if  [ -f ${DESTINATION} ]; then
			sudo mount -o loop,offset=553648128 -t auto ${DESTINATION} ${WORKING_DIR}/mnt/part1
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part1"
				exit -1
			fi
		elif [ -b ${DESTINATION} ]; then
			sudo mount -t auto ${DESTINATION}2 ${WORKING_DIR}/mnt/part1
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part1"
				exit -1
			fi
		fi

		sudo cp -rfT ${PARAM_PATH_OVERLAY} ${WORKING_DIR}/mnt/part1
		if ! [ $? == 0 ]; then
			echo "OVERLAY can't be updated"
			exit -1
		fi

		sudo umount -l ${WORKING_DIR}/mnt/part1
	fi

	if [ ${PARAM_PATH_LINUX_MODULES} ]; then
		echo "****************"
		echo "Updating LINUX_MODULES"

		if ! [ -d ${PARAM_PATH_LINUX_MODULES} ]; then
			echo "Directory doesn't exist: ${PARAM_PATH_LINUX_MODULES}"
			exit -1
		fi

		if  [ -f ${DESTINATION} ]; then
			sudo mount -o loop,offset=553648128 -t auto ${DESTINATION} ${WORKING_DIR}/mnt/part1
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part1"
				exit -1
			fi
		elif [ -b ${DESTINATION} ]; then
			sudo mount -t auto ${DESTINATION}2 ${WORKING_DIR}/mnt/part1
			if ! [ $? == 0 ]; then
				echo "File ${DESTINATION} can't be mounted to ${WORKING_DIR}/mnt/part1"
				exit -1
			fi
		fi

		sudo cp -rf ${PARAM_PATH_LINUX_MODULES} ${WORKING_DIR}/mnt/part1/lib/modules/
		if ! [ $? == 0 ]; then
			echo "LINUX_MODULES can't be updated"
			exit -1
		fi

		sudo umount -l ${WORKING_DIR}/mnt/part1
	fi

}

create_spi_image() {

	WORKING_DIR=${1}

	CONFIGURATION=${2}

	echo
	echo "Working directory is ${WORKING_DIR}"

	echo "Cleaning working directory"
	rm -rf ${WORKING_DIR}

	mkdir ${WORKING_DIR}

	echo "Copying binaries into working directory"
	cp ${PARAM_PATH_IDBLOCK}				${WORKING_DIR}/${IDBLOCK}
	cp ${PARAM_PATH_UBOOT}					${WORKING_DIR}/${UBOOT}
	cp ${PARAM_PATH_DTB}					${WORKING_DIR}/${DTB}

	echo "Making u-boot environmet image"
	mkenvimage -s 0x8000 -o ${WORKING_DIR}/${UBOOT_ENV} ${PARAM_PATH_UBOOT_ENV_TXT} 2>/dev/null

	echo "Making magic section for resulting image"
	echo "atb-magic" > ${WORKING_DIR}/atb-magic

	rm -rf ${GENIMAGE_TMP}
	
	ROOTPATH_TMP="$(mktemp -d)"
	GENIMAGE_TMP="${WORKING_DIR}/genimage.tmp"


	echo "Making resulting image"
	genimage --rootpath ${ROOTPATH_TMP} --tmppath ${GENIMAGE_TMP} --inputpath ${WORKING_DIR} --outputpath ${WORKING_DIR} --config ${PARAM_PATH_GENIMAGE_CFG}

	rm -rf ${GENIMAGE_TMP}

	if ! [ $? == 0 ]; then
		echo "Image can't be created"
		exit -1
	fi

	mv "${WORKING_DIR}/spi.img" "${WORKING_DIR}/`basename ${CONFIGURATION} | cut -d"." -f1`_spi.img"

	echo
	echo
	echo "		sudo dd if=${WORKING_DIR}/`basename ${CONFIGURATION} | cut -d"." -f1`_spi.img of=/dev/sdX status=progress bs=1M"
	echo
	echo
	echo "Currently host system has the following block devices which could be used for writing image."
	echo
	lsblk
}

create_full_image() {

	echo
	echo "Working directory is ${WORKING_DIR}"

	echo "Cleaning working directory"
	rm -rf ${WORKING_DIR}

	mkdir ${WORKING_DIR}

	echo "Copying binaries into working directory"
	cp ${PARAM_PATH_IDBLOCK}				${WORKING_DIR}/${IDBLOCK}
	cp ${PARAM_PATH_UBOOT}					${WORKING_DIR}/${UBOOT}
	cp ${PARAM_PATH_DTB}					${WORKING_DIR}/${DTB}
	cp ${PARAM_PATH_LINUX_KERNEL}			${WORKING_DIR}/${LINUX}
	cp ${PARAM_PATH_EXTERNAL_ROOTFS}		${WORKING_DIR}/${EXTERNAL_ROOTFS}

	echo "Making busybox rootfs image"
	mkimage -A arm -T ramdisk -C gzip -d ${PARAM_PATH_BUSYBOX_ROOTFS} ${WORKING_DIR}/${BUSYBOX_ROOTFS}  1>/dev/null 2>/dev/null

	echo "Making u-boot environmet image"
	mkenvimage -s 0x8000 -o ${WORKING_DIR}/${UBOOT_ENV} ${PARAM_PATH_UBOOT_ENV_TXT} 2>/dev/null

	echo "Preparing extternal rootfs"
	mountpoint ${WORKING_DIR}/mnt -q
	if [ $? == 0 ]; then
		sudo umount ${WORKING_DIR}/mnt
	fi
	sudo rm -rf ${WORKING_DIR}/mnt

	mkdir ${WORKING_DIR}/mnt

	sudo mount ${WORKING_DIR}/${EXTERNAL_ROOTFS} ${WORKING_DIR}/mnt
	if ! [ $? == 0 ]; then
		echo "File ${EXTERNAL_ROOTFS} can't be mount to ./mnt directory"
		exit -1
	fi

	echo "Copying overlay into external rootfs"
	sudo cp -rfT ${PARAM_PATH_OVERLAY} ${WORKING_DIR}/mnt/

	echo "Copying linux kernel modules into external rootfs"
	sudo cp -rf ${PARAM_PATH_LINUX_MODULES} ${WORKING_DIR}/mnt/lib/modules/

	sudo umount ${WORKING_DIR}/mnt

	sudo rm -rf ${WORKING_DIR}/mnt

	ROOTPATH_TMP="$(mktemp -d)"

	echo "Making magic section for resulting image"
	echo "atb-magic" > ${WORKING_DIR}/atb-magic

	rm -rf ${GENIMAGE_TMP}

	GENIMAGE_TMP="${WORKING_DIR}/genimage.tmp"

	echo "Making resulting image"
	genimage --rootpath ${ROOTPATH_TMP} --tmppath ${GENIMAGE_TMP} --inputpath ${WORKING_DIR} --outputpath ${WORKING_DIR} --config ${PARAM_PATH_GENIMAGE_CFG}

	rm -rf ${GENIMAGE_TMP}

	if ! [ $? == 0 ]; then
		echo "Image can't be created"
		exit -1
	fi

	mv "${WORKING_DIR}/spi.img" "${WORKING_DIR}/`basename ${CONFIGURATION} | cut -d"." -f1`_usd.img"

	echo
	echo
	echo "		sudo dd if=${WORKING_DIR}/`basename ${CONFIGURATION} | cut -d"." -f1`_usd.img of=/dev/sdX status=progress bs=1M"
	echo
	echo
	echo "Currently host system has the following block devices which could be used for writing image."
	echo
	lsblk
}

task_create() {

	if [ ${CONFIGURATION} ]; then
		if [ -f ${CONFIGURATION} ]; then
			read_configuration
			if ! [ $? == 0 ]; then
				echo "Configuration file ${CONFIGURATION} can't be read"
				exit -1
			fi
			WORKING_DIR=`basename -s ".cfg" ${CONFIGURATION} | cut -d"." -f1`"_tmp"
		else
			WORKING_DIR="${CONFIGURATION}_tmp"
		fi
	else
		echo "Invalid configuration"
	fi

	echo "PARAM_PATH_IDBLOCK: ${PARAM_PATH_IDBLOCK}"
	echo "PARAM_PATH_UBOOT: ${PARAM_PATH_UBOOT}"
	echo "PARAM_PATH_UBOOT_ENV_TXT: ${PARAM_PATH_UBOOT_ENV_TXT}"
	echo "PARAM_PATH_LINUX_KERNEL: ${PARAM_PATH_LINUX_KERNEL}"
	echo "PARAM_PATH_DTB: ${PARAM_PATH_DTB}"
	echo "PARAM_PATH_BUSYBOX_ROOTFS: ${PARAM_PATH_BUSYBOX_ROOTFS}"
	echo "PARAM_PATH_EXTERNAL_ROOTFS: ${PARAM_PATH_EXTERNAL_ROOTFS}"
	echo "PARAM_PATH_OVERLAY: ${PARAM_PATH_OVERLAY}"
	echo "PARAM_PATH_LINUX_MODULES: ${PARAM_PATH_LINUX_MODULES}"
	echo "PARAM_PATH_GENIMAGE_CFG: ${PARAM_PATH_GENIMAGE_CFG}"

	if ! [ -f ${PARAM_PATH_IDBLOCK} ]; then
		echo "File doesn't exist: ${PARAM_PATH_IDBLOCK}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_UBOOT} ]; then
		echo "File doesn't exist: ${PARAM_PATH_UBOOT}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_UBOOT_ENV_TXT} ]; then
		echo "File doesn't exist: ${PARAM_PATH_UBOOT_ENV_TXT}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_LINUX_KERNEL} ]; then
		echo "File doesn't exist: ${PARAM_PATH_LINUX_KERNEL}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_DTB} ]; then
		echo "File doesn't exist: ${PARAM_PATH_DTB}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_BUSYBOX_ROOTFS} ]; then
		echo "File doesn't exist: ${PARAM_PATH_BUSYBOX_ROOTFS}"
		exit -1
	fi

	if ! [ -d ${PARAM_PATH_OVERLAY} ]; then
		echo "Directory doesn't exist: ${PARAM_PATH_OVERLAY}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_EXTERNAL_ROOTFS} ]; then
		echo "File doesn't exist: ${PARAM_PATH_EXTERNAL_ROOTFS}"
		exit -1
	fi

	if ! [ -d ${PARAM_PATH_LINUX_MODULES} ]; then
		echo "Directory doesn't exist: ${PARAM_PATH_LINUX_MODULES}"
		exit -1
	fi

	if ! [ -f ${PARAM_PATH_GENIMAGE_CFG} ]; then
		echo "File doesn't exist: ${PARAM_PATH_GENIMAGE_CFG}"
		exit -1
	fi

	##**************************************************************************

	create_spi_image ${WORKING_DIR} ${CONFIGURATION}
	
#	create_full_image  ${WORKING_DIR} ${CONFIGURATION}

}

task_update() {

	if  [ ${CONFIGURATION} ]; then
		if  [ -e ${CONFIGURATION} ]; then
				read_configuration
		fi
	fi

	echo "PARAM_PATH_IDBLOCK: ${PARAM_PATH_IDBLOCK}"
	echo "PARAM_PATH_UBOOT: ${PARAM_PATH_UBOOT}"
	echo "PARAM_PATH_UBOOT_ENV_TXT: ${PARAM_PATH_UBOOT_ENV_TXT}"
	echo "PARAM_PATH_LINUX_KERNEL: ${PARAM_PATH_LINUX_KERNEL}"
	echo "PARAM_PATH_DTB: ${PARAM_PATH_DTB}"
	echo "PARAM_PATH_BUSYBOX_ROOTFS: ${PARAM_PATH_BUSYBOX_ROOTFS}"
	echo "PARAM_PATH_EXTERNAL_ROOTFS: ${PARAM_PATH_EXTERNAL_ROOTFS}"
	echo "PARAM_PATH_OVERLAY: ${PARAM_PATH_OVERLAY}"
	echo "PARAM_PATH_LINUX_MODULES: ${PARAM_PATH_LINUX_MODULES}"
	echo "PARAM_PATH_GENIMAGE_CFG: ${PARAM_PATH_GENIMAGE_CFG}"

	if ! [ ${DESTINATION} ]; then
		echo "Destination file is empty"
		exit -1
	fi

	TYPE=`sudo file -sb ${DESTINATION} | cut -d";" -f1`
	echo "TYPE: ${TYPE}"
	if ! [[ ${TYPE} == "DOS/MBR boot sector" ]]; then
		echo "File ${DESTINATION} isn't block device or image of block device"
		exit -1
	fi

	ATB_MAGIC=`sudo dd if=${DESTINATION} skip=2M bs=1 count=16 2>/dev/null | tr -d '\0'`
	echo "ATB_MAGIC: ${ATB_MAGIC}"

	if ! [[ ${ATB_MAGIC} == "atb-magic" ]]; then
		echo "File ${DESTINATION} is wrong format"
		exit -1
	fi

# Examine ${DESTINATION} file. It might be: a file of image, a block device, other(incorrect)

	if  [ -f ${DESTINATION} ]; then
		echo "Being updated file ${DESTINATION} is an image of block device"
	elif [ -b ${DESTINATION} ]; then
		echo "Being updated file ${DESTINATION} is a block device"
	else
		echo "File ${DESTINATION} is unknown format"
		exit -1
	fi

	WORKING_DIR="distr_tmp"

	sudo rm -rf ${WORKING_DIR}

	mkdir -p ${WORKING_DIR}/mnt/part0 ${WORKING_DIR}/mnt/part1

	fill_with_data

	sudo rm -rf ${WORKING_DIR}

}

#
# Entry point
#
if [ ${#} == 0 ]; then
	echo "Invalid arguments"
	exit -1
fi

while [[ "$#" -gt 0 ]]; do
	case $1 in
		"--task")
			TASK=${2}
			shift 
		;;

		"--configuration")
			CONFIGURATION=`realpath ${2}`
			shift
		;;

		"--destination")
			DESTINATION=`realpath ${2}`
			shift
		;;

		"--linux")
			PARAM_PATH_LINUX_KERNEL=`realpath ${2}`
			shift
		;;

		"--linux_modules")
			PARAM_PATH_LINUX_MODULES=`realpath ${2}`
			shift
		;;

		"--uboot_env_txt")
			PARAM_PATH_UBOOT_ENV_TXT=`realpath ${2}`
			shift
		;;

		"--uboot")
			PARAM_PATH_UBOOT=`realpath ${2}`
			shift
		;;

		"--dtb")
			PARAM_PATH_DTB=`realpath ${2}`
			shift
		;;

		"--idblock")
			PARAM_PATH_IDBLOCK=`realpath ${2}`
			shift
		;;

		"--overlay")
			PARAM_PATH_OVERLAY=`realpath ${2}`
			shift
		;;

		"--busybox_rootfs")
			PARAM_PATH_BUSYBOX_ROOTFS=`realpath ${2}`
			shift
		;;

		"--external_rootfs")
			PARAM_PATH_EXTERNAL_ROOTFS=`realpath ${2}`
			shift
		;;

		"--genimage_cfg")
			PARAM_PATH_GENIMAGE_CFG=`realpath ${2}`
			shift
		;;

		*)
			echo "Unknown parameter passed: $1"
			exit -1
		;;
	esac

	shift
done

echo "TASK: ${TASK}"
echo "CONFIGURATION: ${CONFIGURATION}"
echo "DESTINATION: ${DESTINATION}"

case ${TASK} in
	"create")
		echo
		echo "Creation was activated"
		task_create
	;;

	"update")
		echo
		echo "Updating was activated"
		task_update
	;;

	*)
		echo "Unknown task: ${TASK}"
		exit -1
esac
