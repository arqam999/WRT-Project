#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

HWOSDIR="package/base-files/files"

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' $HWOSDIR/bin/config_generate

# Switch dir to package/lean
pushd package/lean

# Add luci-app-ssr-plus
#git clone --depth=1 https://github.com/fw876/helloworld

# Remove luci-app-uugamebooster and luci-app-xlnetacc
#rm -rf luci-app-uugamebooster
#rm -rf luci-app-xlnetacc

# Exit from package/lean dir
popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall
sed -i 's/ upx\/host//g' openwrt-passwall/v2ray-plugin/Makefile
grep -lr upx/host openwrt-passwall/* | xargs -t -I {} sed -i '/upx\/host/d' {}

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash

# Add luci-app-diskman
#git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
#mkdir parted
#cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add luci-app-wrtbwmon
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-wrtbwmon
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/wrtbwmon
rm -rf ../lean/luci-app-wrtbwmon

# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon

#-----------------------------------------------------------------------------
#   Start of @helmiau additionals packages for cloning repo 
#-----------------------------------------------------------------------------

# Add modeminfo
#git clone --depth=1 https://github.com/koshev-msk/luci-app-modeminfo

# Add luci-app-smstools3
#git clone --depth=1 https://github.com/koshev-msk/luci-app-smstools3

# Add luci-app-mmconfig : configure modem cellular bands via mmcli utility
#git clone --depth=1 https://github.com/koshev-msk/luci-app-mmconfig

# Add support for Fibocom L860-GL l850/l860 ncm
#git clone --depth=1 https://github.com/koshev-msk/xmm-modem

# Add 3ginfo, luci-app-3ginfo
#git clone --depth=1 https://github.com/4IceG/luci-app-3ginfo

# Add luci-app-sms-tool
#git clone --depth=1 https://github.com/4IceG/luci-app-sms-tool

# Add luci-app-atinout-mod
#git clone --depth=1 https://github.com/4IceG/luci-app-atinout-mod

# HelmiWrt packages
git clone --depth=1 https://github.com/helmiau/helmiwrt-packages

# Add themes from kenzok8 openwrt-packages
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-atmaterial_new kenzok8/luci-theme-atmaterial_new
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge kenzok8/luci-theme-edge
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-ifit kenzok8/luci-theme-ifit
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-opentomato kenzok8/luci-theme-opentomato
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-opentomcat kenzok8/luci-theme-opentomcat
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-opentopd kenzok8/luci-theme-opentopd

#-----------------------------------------------------------------------------
#   End of @helmiau additionals packages for cloning repo 
#-----------------------------------------------------------------------------


popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p pool.ntp.org)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} ${date_version}/g" zzz-default-settings
sed -i "s/zh_cn/auto/g" zzz-default-settings
sed -i "s/uci set system.@system[0].timezone=CST-8/uci set system.@system[0].hostname=Mi4AG\nuci set system.@system[0].timezone=MYT-8/g" zzz-default-settings
sed -i "s/Shanghai/Kuala Lumpur/g" zzz-default-settings
popd

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Change default shell to zsh
#sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' $HWOSDIR/etc/passwd

#-----------------------------------------------------------------------------

# Update Version
sed -i 's/Newifi D2/Mi 4A Gigabit/g' files/etc/banner
echo -e "          Built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> files/etc/banner
sed -i "s/OpenWrt /GilaGajet build $(TZ=UTC+8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings


############REMOVE LEDE CONFIG############


# Remove default LEDE app
#rm -rf package/lean/luci-app-autoreboot
#rm -rf package/lean/luci-app-filetransfer
#rm -rf package/lean/luci-app-turboacc
#rm -rf package/lean/luci-app-unblockmusic
#rm -rf package/lean/luci-app-vlmcsd
#rm -rf package/lean/luci-app-vsftpd

#rm -rf package/lean/ddns-scripts_aliyun
#rm -rf package/lean/ddns-scripts_dnspod

# Add zram-swap
echo 'CONFIG_PACKAGE_zram-swap=y' >> .config
echo 'CONFIG_PACKAGE_kmod-zram=y' >> .config
echo 'CONFIG_PROCD_ZRAM_TMPFS=y' >> .config


# Add stunnel
#echo 'CONFIG_PACKAGE_stunnel=y' >> .config


# Add mwan3
#echo 'CONFIG_PACKAGE_luci-app-mwan3=y' >> .config
#echo 'CONFIG_PACKAGE_mwan3=y' >> .config 

# Add kernel build user
sed -i 's/CONFIG_KERNEL_BUILD_USER=""/CONFIG_KERNEL_BUILD_USER="gilagajet"/g' .config


# Add kernel build domain
sed -i 's/CONFIG_KERNEL_BUILD_DOMAIN=""/CONFIG_KERNEL_BUILD_DOMAIN="modem.my"/g' .config

# Update TimeZone
sed -i 's/ntp.aliyun.com/time.google.com/g' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/time.cloudflare.com/g' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/clock.sjc.he.net/g' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/my.pool.ntp.org/g' package/base-files/files/bin/config_generate
