#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

# Enable WiFi Interface
sed -i 's/wireless.radio${devidx}.disabled=1/wireless.radio${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Fix mt76 wireless driver
#pushd package/kernel/mt76
#sed -i ' /mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1> $\(1\)\/etc\/modules.d\/mt76-usb ' Makefile
#popd

#Copy patches wireless driver
#cp $GITHUB_WORKSPACE/patches/mt7603-for-mt7621-linux-4.14.167.ko feeds/mtk/drivers/mt7603
#cp $GITHUB_WORKSPACE/patches/mt7612-for-mt7621-linux-4.14.167.ko feeds/mtk/drivers/mt7612


#Fix mt7603 wireless driver
#pushd feeds/mtk/drivers/mt7603
#sed -i 's/PKG_KO:=$(PKG_NAME)-for-$(CONFIG_TARGET_SUBTARGET)-linux-$(LINUX_VERSION).ko/PKG_KO:=$(PKG_NAME)-for-$(CONFIG_TARGET_SUBTARGET)-linux-4.14.167.ko/g' Makefile 
#popd

#Fix mt7612 wireless driver
#pushd feeds/mtk/drivers/mt7612
#sed -i 's/PKG_KO:=$(PKG_NAME)-for-$(CONFIG_TARGET_SUBTARGET)-linux-$(LINUX_VERSION).ko/PKG_KO:=$(PKG_NAME)-for-$(CONFIG_TARGET_SUBTARGET)-linux-4.14.167.ko/g' Makefile 
#popd

#Copy custom folder
#cp -r $GITHUB_WORKSPACE/files/ files

# Modify hostname
sed -i 's/OpenWrt/Lenovo-Newifi-D2/g' package/base-files/files/bin/config_generate

# Modify the version number
#sed -i "s/OpenWrt /teasiu build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# Add kernel build user
sed -i 's/CONFIG_KERNEL_BUILD_USER=""/CONFIG_KERNEL_BUILD_USER="gilagajet"/g' .config

# Add kernel build domain
sed -i 's/CONFIG_KERNEL_BUILD_DOMAIN=""/CONFIG_KERNEL_BUILD_DOMAIN="modem.my"/g' .config


# Add luci-app-passwall
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

#Remove Passwall Geo-Data
pushd feeds/xiao/luci-app-passwall
sed -i 's/+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/#+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/g' Makefile
popd

# Add luci-app-vssr
pushd package
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr
popd

# Add OpenClash
pushd package
git clone --depth=1 -b master https://github.com/vernesong/OpenClash
popd

# Add luci-theme-argon
pushd package
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
popd

# Modify default theme
pushd feeds/luci/collections/luci
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' Makefile
popd
#package/feeds/luci/luci/
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' Makefile
#popd
sed -i 's/bootstrap/luci-theme-argon/g feeds/luci/modules/luci-base/root/etc/config/luci

# Time stamp with $Build_Date=$(date +%Y.%m.%d)
#echo -e '\nQuintus Build@'$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
#sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
#echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
#sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
#echo "DISTRIB_DESCRIPTION='Quintus Build@$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release

echo -e '\nOpenwRT By GilaGajet\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='[Public Edition]'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWRT By GilaGajet $(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
