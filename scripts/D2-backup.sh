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

export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

# Enable WiFi Interface
sed -i 's/wireless.radio${devidx}.disabled=1/wireless.radio${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# Modify hostname
sed -i 's/OpenWrt/Lenovo-Newifi-D2/g' package/base-files/files/bin/config_generate

# Add kernel build user
sed -i 's/CONFIG_KERNEL_BUILD_USER=""/CONFIG_KERNEL_BUILD_USER="gilagajet"/g' .config

# Add kernel build domain
sed -i 's/CONFIG_KERNEL_BUILD_DOMAIN=""/CONFIG_KERNEL_BUILD_DOMAIN="modem.my"/g' .config

#Remove Passwall Geo-Data
pushd feeds/xiao/luci-app-passwall
sed -i 's/+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/#+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/g' Makefile
popd

# Add luci-app-vssr
pushd package
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr
popd
echo 'CONFIG_PACKAGE_luci-app-vssr=y' >> .config

# Add OpenClash
pushd package
git clone --depth=1 -b master https://github.com/vernesong/OpenClash
popd
echo 'CONFIG_PACKAGE_luci-app-openclash=y' >> .config

# Add luci-theme-argon
pushd package
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
popd

# Modify default theme
pushd feeds/luci/collections/luci
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' Makefile
popd
pushd package/feeds/luci/luci
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' Makefile
popd

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

#Testing VSSR
pushd package
git clone --depth=1 -b https://github.com/jerrykuku/luci-app-vssr.git
popd



