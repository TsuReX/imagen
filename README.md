##### imagen.sh has the following commands  

`--task create | update`  
Required parameter which activates one of two available modes: *creation* of image from scratch or *updating* internals of image/block device in relation with give parameters.  

`--configuration <path>`  
Required parameter in case of creation mode. The parameter specifies path to a configuration file.  
The configuration file can consist of the following set of parameters:  
```
PARAM_PATH_IDBLOCK				buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/idbloader.img
PARAM_PATH_UBOOT				buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/u-boot.itb
PARAM_PATH_UBOOT_ENV_TXT		uboot.env.txt
PARAM_PATH_LINUX_KERNEL			buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/Image
PARAM_PATH_DTB					buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/atb-rk3568j-smc-r1.dtb
PARAM_PATH_BUSYBOX_ROOTFS		buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/images/rootfs.cpio.gz
PARAM_PATH_EXTERNAL_ROOTFS		../dl/debian_12_lxqt_arm64_ext4.img
PARAM_PATH_OVERLAY 				atb_rk3568j_smc_r1_linux-5.10.110_debian12_lxqt/overlay
PARAM_PATH_LINUX_MODULES		buildroot/output/atb_rk3568j_smc_r1_linux-5.10.110/target/lib/modules
PARAM_PATH_GENIMAGE_CFG			distr_image.cfg
```
Parameter `PARAM_PATH_LINUX_MODULES` is an absolute path to `/lib/modules` directory being created during deploying buildroot rootfs and consists of linux kernel modules.  
Parameter `PARAM_PATH_GENIMAGE_CFG` is an absolute path to configuration file which describes internal structure of being created image.  
Parameter `PARAM_PATH_EXTERNAL_ROOTFS`  is an absolute path to raw image of root file system of required distribution (e.g. ubuntu, debian etc.). The distribution can be created by yourself or obtaind from a site of developer.  

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

`--image_type full | spi`  
Parameter specifies what type of image will be generated: full - image for emmc or sd; spi - image for spi nor.  

Create image from scratch using configuration file.  
```bash
./imagen.sh --task create --configuration ./path/atb_rk3568j_smc_r1_linux-5.10.110_debian12_minimal.cfg --image_type full
```

Update existing image using configuration file and using block device as a source for modification.  
```bash
./imagen.sh --task update --configuration ./path/atb_rk3568j_smc_r1_linux-5.10.110_debian12_minimal.cfg --destination /dev/mmcblk1
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
./imagen.sh --task update --configuration ./path/atb_rk3568j_smc_r1_linux-5.10.110_debian12_minimal.cfg --destination /dev/mmcblk1 --overlay ./path/overlay --linux_modules ./path/lib/modules
```

For creating image from scratch all of these parameters are required.  
For updating only certain parameters are required. It depends on a purpose of updating.  
Absolute pathes are required.  

The following files are generated during buildroot building process for ATB-RK3568J-SMC-R1 board:  
`idbloader.img`  
`u-boot.itb`  
`Image`  
`atb-rk3568j-smc-r1.dtb`  
`rootfs.cpio.gz`  

##### imagen.sh required the following:
```
sudo apt install -y u-boot-tools libconfuse-dev wget git make gcc u-boot-tools unzip autoconf pkg-config libconfuse-dev mtools
git clone https://github.com/pengutronix/genimage.git --depth=1 --branch=v17
cd genimage
./autogen.sh
./configure CFLAGS='-g -O0' --prefix=/usr
make
sudo make install

```


##### To create image for ATB-RK3568J-SMC-R1 board it needs to do the following steps:  
1. obtain building system  
```
git clone https://git1.atb-e.ru/cpu_soft/build_systems/imagen.git  --depth=1 --branch=refactoring imagen
```

2. go into directory  
```
cd imagen
```

3. obtain dl  
```
mkdir dl ftp_dl
curlftpfs -o user="atbftp_user:32Vj_hy%c@gR" ftp.atb-e.ru:2121/ATB_FTP/buildroot/dl ftp_dl
cp -r ./ftp_dl/* ./dl
sudo umount ftp_dl
rm -rf ./ftp_dl`  
```

4. obtain buildroot  
```
git clone https://git1.atb-e.ru/cpu_soft/build_systems/atb-buildroot-main.git --depth=1 --branch=develop buildroot
```

5. go into directory  
```
cd buildroot
```

6. make a link to dl directory  
```
ln -s ../dl dl
```

7. configure and build base image  
```
make O=output/atb_rk3568j_smc_r1_linux-5.10.110 atb_rk3568j_smc_r1_linux-5.10.110_defconfig
make O=output/atb_rk3568j_smc_r1_linux-5.10.110
```

8. leave directory  
```
cd ..
```

9. create image   
```
sudo dd if=atb_rk3568j_smc_r1_linux-5_tmp/atb_rk3568j_smc_r1_linux-5_usd.img of=/dev/sdX status=progress bs=1M
```
