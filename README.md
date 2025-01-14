## Introduction
This document describes how to create image for ATB-RK3568J-SMC-R1 board. The following instructions are designed to work on Ubuntu systems.

> **You are free to try it on any other Linux distribution, but you won't get any support in this case.** 

> **In order to get support please build on Ubuntu system**
## Prerequisites
In order to successfully build image for ATB-RK3568J-SMC-R1 board you need to install following dependencies:
```shell
sudo apt update
sudo apt install -y u-boot-tools libconfuse-dev wget git make gcc g++ unzip autoconf pkg-config libconfuse-dev mtools python2
git clone https://github.com/pengutronix/genimage.git --depth=1 --branch=v17
cd genimage
./autogen.sh
./configure CFLAGS='-g -O0' --prefix=/usr
make
sudo make install
```
## ATB-RK3568J-SMC-R1 image creation instruction  
1. Obtain building system  
```shell
git clone https://git1.atb-e.ru/cpu_soft/build_systems/imagen.git --branch=r0.2 imagen
```

2. Go into imagen directory  
```shell
cd imagen
```

3. Download additional files for build. For this you have following options:

- Via ftp:
```shell
mkdir dl ftp_dl
curlftpfs -o user="atbftp_user:32Vj_hy%c@gR" ftp.atb-e.ru:2121/ATB_FTP/buildroot/dl ftp_dl
cp -r ./ftp_dl/* ./dl
sudo umount ftp_dl
rm -rf ./ftp_dl  
```
- Via following link: <https://disk.yandex.ru/d/LATMTVkmq60rCQ>

>**dl folder **must** reside in imagen directory!**

>**In case you want to place it somewhere else, you should create symlink in imagen directory.**

4. Obtain buildroot  
```shell
git clone https://git1.atb-e.ru/cpu_soft/build_systems/atb-buildroot-main.git --branch=dr2 buildroot
```

5. Go into buildroot directory  
```shell
cd buildroot
```

6. Make a link to dl directory  
```shell
ln -s ../dl dl
```

7. Configure and build base image  
```shell
make O=output/atb_rk3568j_smc_r1_linux-5.10.110 atb_rk3568j_smc_r1_linux-5.10.110_defconfig
make O=output/atb_rk3568j_smc_r1_linux-5.10.110
```

8. Leave buildroot directory  
```shell
cd ../
```

9. Create image for SD card 
```shell
./imagen.sh --task create --image_type full --configuration atb_rk3568j_smc_r1/linux-5.10.110_debian12_lxqt.cfg
```

10. Write image to SD card 
```shell
sudo dd if=linux-5_tmp/linux-5_usd.img of=/dev/sdX status=progress bs=1M; sync
```
## imagen.sh has the following commands  

`--task create | update`  
Required parameter which activates one of two available modes: *creation* of image from scratch or *updating* internals of image/block device in relation with give parameters.  

`--image_type full | spi`  
Required parameter specifies what type of image will be generated: full - image for emmc or sd; spi - image for spi nor.  

`--configuration <path>`  
Required parameter in case of creation mode. The parameter specifies path to a configuration file.  

The configuration file can consist of the following set of parameters:  

|Parameter                  |Description                                                                     |
|:--------------------------|:-------------------------------------------------------------------------------|
|PARAM_PATH_IDBLOCK			|buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/idbloader.img         |
|PARAM_PATH_UBOOT			|buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/u-boot.itb            |
|PARAM_PATH_UBOOT_ENV_TXT	|uboot.env.txt                                                                   |
|PARAM_PATH_LINUX_KERNEL	|buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/Image                 |
|PARAM_PATH_DTB				|buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/atb-rk3568j-smc-r1.dtb|
|PARAM_PATH_BUSYBOX_ROOTFS	|buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/rootfs.cpio.gz        |
|PARAM_PATH_EXTERNAL_ROOTFS	|dl/debian_12_lxqt_arm64_ext4.img                                                |
|PARAM_PATH_OVERLAY 		|linux-5.10.110_debian12_lxqt/overlay                                            |
|PARAM_PATH_LINUX_MODULES	|buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/target/lib/modules           |
|PARAM_PATH_GENIMAGE_CFG	|distr_image.cfg                                                                 |

- Parameter `PARAM_PATH_LINUX_MODULES` is an absolute path to `/lib/modules` directory being created during deploying buildroot rootfs and consists of linux kernel modules.  
- Parameter `PARAM_PATH_GENIMAGE_CFG` is an absolute path to configuration file which describes internal structure of being created image.  
- Parameter `PARAM_PATH_EXTERNAL_ROOTFS`  is an absolute path to raw image of root file system of required distribution (e.g. ubuntu, debian etc.). The distribution can be created by yourself or obtaind from a site of developer.  

`--destination <path>`  
Required parameter in case of updating mode. The parameter specify path to image file of block device which internals will be updated.  

`--linux <path>`  
Parameter specifies path to linux kernel file. The parameter overrides related one in configuration file if it is specified.  

`--linux_modules <path>`  
Parameter specifies path to a directory which contains linux kernel modules. The parameter overrides related one in configuration file if it is specified.  

`--uboot_env_txt <path>`  
Parameter specifies path to file which contains environment variables of u-boot. The parameter overrides related one in configuration file if it is specified.  

`--uboot <path>`  
Parameter specifies path to u-boot image file being built by buildroot. The parameter overrides related one in configuration file if it is specified.  

`--dtb <path>`  
Parameter specifies path to device tree blob file for linux kernel. The parameter overrides related one in configuration file if it is specified.  

`--idblock <path>`  
Parameter specifies path to the first stage bootloader being built by buildroot. The parameter overrides related one in configuration file if it is specified.  

`--overlay <path>`  
Parameter specifies path to a directory with subdirectories wich will be copied into root of root file system. The parameter overrides related one in configuration file if it is specified.  

`--busybox_rootfs <path>`  
Parameter specifies path to a root file system being generated by buildroot. The parameter overrides related one in configuration file if it is specified.  

`--external_rootfs <path>`  
Parameter specifies path to a root file system for example ubuntu/debian e.t.c.. The parameter overrides related one in configuration file if it is specified.  

`--genimage_cfg <path>`  
Parameter specifies path to a configuration file for genimage utility which describes structure of final image. The parameter overrides related one in configuration file if it is specified.  

Create image from scratch using configuration file.  
```bash
./imagen.sh --task create --image_type full --configuration atb_rk3568j_smc_r1/linux-5.10.110_debian12_minimal.cfg
```

Update existing image using configuration file and using block device as a source for modification.  
```bash
./imagen.sh --task update --configuration atb_rk3568j_smc_r1/linux-5.10.110_debian12_minimal.cfg --destination /dev/mmcblk1
```

Update existing image using certain parameters and using block device as a source for modification.  
```bash
./imagen.sh --task update --linux_modules ./path/lib/modules --uboot_env_txt ./path/uboot_env.txt --destination /dev/sda
```

Update existing image using certain parameters and using image file as a source for modification.  
```bash
./imagen.sh --task update --idblock ./path/idbloader.img --uboot ./path/uboot --destination ./path/usd.img
```

Update existing image using configuration file and certain parameters and using block device as a source for modification.  
In this case parameters `--overlay` and `--linux_modules` override the same parameters in configuration file.  
```bash
./imagen.sh --task update --configuration atb_rk3568j_smc_r1/linux-5.10.110_debian12_minimal.cfg --destination /dev/mmcblk1 --overlay ./path/overlay --linux_modules ./path/lib/modules
```

For creating image from scratch all of these parameters are required.  
For updating only certain parameters are required. It depends on a purpose of updating.  
Absolute pathes are required.  

The following files are generated during buildroot building process for ATB-RK3568J-SMC-R1 board:  
- `idbloader.img`  
- `u-boot.itb`  
- `Image`  
- `atb-rk3568j-smc-r1.dtb`  
- `rootfs.cpio.gz`  

