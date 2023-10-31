#!/bin/bash

PARAM_PATH_DEST=""
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

TEST_NUM=""
test_image_file() {

	PARAM_PATH_DEST="./atb_rk3568c_mpc_m_ubuntu_minimal_tmp/atb_rk3568c_mpc_m_ubuntu_minimal_usd.img"
	PARAM_PATH_IDBLOCK="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/idblock.bin"
	PARAM_PATH_UBOOT="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/uboot.img"
	PARAM_PATH_UBOOT_ENV_TXT="/home/user/drive/workspace/distr_builder/uboot.env.txt"
	PARAM_PATH_LINUX_KERNEL="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/linux"
	PARAM_PATH_DTB="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/dtb"
	PARAM_PATH_BUSYBOX_ROOTFS="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/rootfs.cpio.gz"
	PARAM_PATH_EXTERNAL_ROOTFS="/home/user/drive/workspace/buildroot-mpc-m/dl/ubuntu20.04-minimal.rootfs.ext4"
	PARAM_PATH_OVERLAY="/home/user/drive/workspace/buildroot-mpc-m/board/atb/atb_rk3568c_mpc_m/overlay"
	PARAM_PATH_LINUX_MODULES="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/target/lib/modules/"
	PARAM_PATH_UBOOTTOOLS="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/build/uboot-ok_r1/tools/"
	PARAM_PATH_GENIMAGE="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/host/bin/genimage"
	PARAM_PATH_GENIMAGE_CFG="/home/user/drive/workspace/distr_builder/distr_image.cfg"

	TEST_NUM="1"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task create \
						--configuration			./atb_rk3568c_mpc_m_ubuntu_minimal.cfg
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="2"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task create \
						--configuration			atb_rk3568c_mpc_m_ubuntu_minimal \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--genimage				${PARAM_PATH_GENIMAGE} \
						--genimage_cfg			${PARAM_PATH_GENIMAGE_CFG} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY} \
						--linux_modules			${PARAM_PATH_LINUX_MODULES}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="3"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--configuration			./atb_rk3568c_mpc_m_ubuntu_minimal.cfg \
						--destination			${PARAM_PATH_DEST}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="4"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--idblock				${PARAM_PATH_IDBLOCK}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="5"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="6"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT}


	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="7"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="8"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="9"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="10"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="11"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="12"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY} \
						--linux_modules			${PARAM_PATH_LINUX_MODULES}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="13"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${PARAM_PATH_DEST} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY} \
						--linux_modules			${PARAM_PATH_LINUX_MODULES} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--genimage				${PARAM_PATH_GENIMAGE} \
						--genimage_cfg			${PARAM_PATH_GENIMAGE_CFG}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""
}

test_block_device() {

	PARAM_PATH_DEST=${1}
	PARAM_PATH_IDBLOCK="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/idblock.bin"
	PARAM_PATH_UBOOT="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/uboot.img"
	PARAM_PATH_UBOOT_ENV_TXT="/home/user/drive/workspace/distr_builder/uboot.env.txt"
	PARAM_PATH_LINUX_KERNEL="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/linux"
	PARAM_PATH_DTB="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/dtb"
	PARAM_PATH_BUSYBOX_ROOTFS="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/images/rootfs.cpio.gz"
	PARAM_PATH_EXTERNAL_ROOTFS="/home/user/drive/workspace/buildroot-mpc-m/dl/ubuntu20.04-minimal.rootfs.ext4"
	PARAM_PATH_OVERLAY="/home/user/drive/workspace/buildroot-mpc-m/board/atb/atb_rk3568c_mpc_m/overlay"
	PARAM_PATH_LINUX_MODULES="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/target/lib/modules/"
	PARAM_PATH_UBOOTTOOLS="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/build/uboot-ok_r1/tools/"
	PARAM_PATH_GENIMAGE="/home/user/drive/workspace/buildroot-mpc-m/output/mpc_m/host/bin/genimage"
	PARAM_PATH_GENIMAGE_CFG="/home/user/drive/workspace/distr_builder/distr_image.cfg"

	TEST_NUM="101"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--configuration			./atb_rk3568c_mpc_m_ubuntu_minimal.cfg \
						--destination			${1}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="102"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--idblock				${PARAM_PATH_IDBLOCK}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="103"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="104"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT}


	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="105"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="106"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="107"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="108"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="109"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="110"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY} \
						--linux_modules			${PARAM_PATH_LINUX_MODULES}

	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""

	TEST_NUM="111"
	echo "**************"
	echo "TEST ${TEST_NUM}"
	echo "**************"
	./distr_builder.sh	--task update \
						--destination			${1} \
						--idblock				${PARAM_PATH_IDBLOCK} \
						--uboot					${PARAM_PATH_UBOOT} \
						--uboot_env_txt			${PARAM_PATH_UBOOT_ENV_TXT} \
						--linux					${PARAM_PATH_LINUX_KERNEL} \
						--dtb					${PARAM_PATH_DTB} \
						--busybox_rootfs		${PARAM_PATH_BUSYBOX_ROOTFS} \
						--external_rootfs		${PARAM_PATH_EXTERNAL_ROOTFS} \
						--overlay				${PARAM_PATH_OVERLAY} \
						--linux_modules			${PARAM_PATH_LINUX_MODULES} \
						--uboot_tools			${PARAM_PATH_UBOOTTOOLS} \
						--genimage				${PARAM_PATH_GENIMAGE} \
						--genimage_cfg			${PARAM_PATH_GENIMAGE_CFG}
	if ! [ $? == 0 ]; then
		echo "TEST ${TEST_NUM} ERROR"
		echo ""
		exit -1
	fi
	echo "TEST ${TEST_NUM} SUCCESS"
	echo ""
}


if [ ${#} == 0 ]; then
	echo "Invalid arguments"
	exit -1
fi

AGREEMENT=""

if [ -b ${1} ]; then
	echo "The script was given a ${1} file. This file is a block device."
else
	echo "File ${1} isn't a block device."
	exit -1
fi

echo "WARNING!!! PLEASE BE CAREFUL, THE SCRIPT WILL REWRITE DATA BEING STORED ON THIS DEVICE"
echo ""
echo "Type YeS, if you are agree"

read AGREEMENT

if ! [ ${AGREEMENT} == "YeS" ]; then
	echo "Incorrect approvement"
	exit 1
fi

test_image_file

test_block_device ${1}
