Create image from scratch using configuration file.  
```bash
./distr_builder.sh --task create --configuration ./path/atb_rk3568c_mpc_m_ubuntu_minimal.cfg
```

Update existing image using configuration file and using block device as a source for modification.  
```bash
./distr_builder.sh --task update --configuration ./path/atb_rk3568c_mpc_m_ubuntu_minimal.cfg --destination /dev/mmcblk1
```

Update existing image using certain parameters and using block device as a source for modification.  
```bash
./distr_builder.sh --task update --linux_modules ./path/lib/modules --uboot_env_txt ./path/uboot_env.txt --destination /dev/sda
```

Update existing image using certain parameters and using image file as a source for modification.  
```bash
./distr_builder.sh --task update --idblock ./path/idblock.bin --uboot ./path/uboot --destination ./path/usd.img
```

Update existing image using configuration file and certain parameters and using block device as a source for modification.  
In this case parameters `--overlay` and `--linux_modules` override the same parameters in configuration file.  
```bash
./distr_builder.sh --task update --configuration ./path/atb_rk3568c_mpc_m_ubuntu_minimal.cfg --destination /dev/mmcblk1 --overlay ./path/overlay --linux_modules ./path/lib/modules
```

Configuration file can consist of the following set of parameters:  
```
PARAM_PATH_IDBLOCK				/abs_path/distr_builder/buildroot/output/smc-r1/images/idblock.bin
PARAM_PATH_UBOOT				/abs_path/distr_builder/buildroot/output/smc-r1/images/uboot.img
PARAM_PATH_UBOOT_ENV_TXT		/abs_path/distr_builder/uboot.env.txt
PARAM_PATH_LINUX_KERNEL			/abs_path/distr_builder/buildroot/output/smc-r1/images/Image
PARAM_PATH_DTB					/abs_path/distr_builder/buildroot/output/smc-r1/images/atb-rk3568j-smc-r1.dtb
PARAM_PATH_BUSYBOX_ROOTFS		/abs_path/distr_builder/buildroot/output/smc-r1/images/rootfs.cpio.gz
PARAM_PATH_EXTERNAL_ROOTFS		/abs_path/distr_builder/ubuntu18.04-lxde.rootfs.ext4
PARAM_PATH_OVERLAY 				/abs_path/distr_builder/buildroot/board/atb/atb_rk3568j_smc_r1/overlay
PARAM_PATH_LINUX_MODULES		/abs_path/distr_builder/buildroot/output/smc-r1/target/lib/modules
PARAM_PATH_UBOOTTOOLS 			/abs_path/distr_builder/buildroot/output/smc-r1/build/uboot-ok_r1/tools
PARAM_PATH_GENIMAGE 			/abs_path/distr_builder/buildroot/output/smc-r1/host/bin/genimage
PARAM_PATH_GENIMAGE_CFG			/abs_path/distr_builder/distr_image.cfg
```

For creating image from scratch all of these parameters are required.  
For updating only certain parameters are required. It depends on a purpose of updating.  
Absolute pathes are required.  

The following files are generated during buildroot building process:  
`idblock.bin`  
`uboot.img`  
`Image`  
`atb-rk3568j-smc-r1.dtb`  
`rootfs.cpio.gz`  

Parameter `PARAM_PATH_LINUX_MODULES` is an absolute path to `/lib/modules` directory being created during deploying buildroot rootfs and consists of linux kernel modules.  

Parameter `PARAM_PATH_UBOOTTOOLS` is an absolute path to utilities compiled together with u-boot and used for different purposes of image creation.  

Parameter `PARAM_PATH_GENIMAGE` is an absolute path to `genimage` utility being used by buildroot to create final image.  

Parameter `PARAM_PATH_GENIMAGE_CFG` is an absolute path to configuration file which describes internal structure of being created image.  

Parameter `PARAM_PATH_EXTERNAL_ROOTFS`  is an absolute path to raw image of root file system of required distribution (e.g. ubuntu, debian etc.). The distribution can be created by yourself or obtaind from a site of developer.  

To create image it needs to do the following steps:  
1. obtain building system `git clone `https://git1.atb-e.ru/cpu_soft/build_systems/distr_builder.git distr_builder
2. go into directory `cd distr_builder`
3. obtain buildroot `git clone https://git1.atb-e.ru/cpu_soft/build_systems/atb-buildroot-main.git buildroot`
4. go into directory `cd buildroot`
5. configure and build base image  
`make O=output/smc-r1 atb_rk3568j_smc_r1_linux-5.10.110_defconfig`  
`make O=output/smc-r1`  
6. leave directory "cd .."  
7. download distribution `ubuntu18.04-lxde.rootfs.ext4`  
8. create configuration file `atb_rk3568j_smc_r1_ubuntu_minimal.cfg`  
9. fill the created configuration file as mentioned earlier  
10. create image `./distr_builder.sh --task create --configuration ./path/atb_rk3568c_mpc_m_ubuntu_minimal.cfg`  
11. write created image into uSD-card `dd if=atb_rk3568c_mpc_m_ubuntu_minimal_tmp/atb_rk3568c_mpc_m_ubuntu_minimal_usd.img of=/dev/sdX status=progress bs=1M`  
