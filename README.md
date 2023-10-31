Create image from scratch using configuration file  
```bash
./distr_builder.sh --task create --configuration ./path/atb_rk3568c_mpc_m_ubuntu_minimal.cfg
```

Update existing image using configuration file and using block device as a source for modification  
```bash
./distr_builder.sh --task update --configuration ./path/atb_rk3568c_mpc_m_ubuntu_minimal.cfg --destination /dev/mmcblk1
```

Update existing image using certain parameters and using block device as a source for modification  
```bash
./distr_builder.sh --task update --linux_modules ./path/lib/modules --uboot_env_txt ./path/uboot_env.txt --destination /dev/sda
```

Update existing image using configuration file and using image file as a source for modification  
```bash
./distr_builder.sh --task update --idblock ./path/idblock.bin --uboot ./path/uboot --destination ./path/usd.img
```
