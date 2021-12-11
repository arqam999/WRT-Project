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
sed -i 's/ImmortalWrt/DIR842/g' package/base-files/files/bin/config_generate


# Add kernel build user
sed -i 's/CONFIG_KERNEL_BUILD_USER=""/CONFIG_KERNEL_BUILD_USER="gilagajet"/g' .config


# Add kernel build domain
sed -i 's/CONFIG_KERNEL_BUILD_DOMAIN=""/CONFIG_KERNEL_BUILD_DOMAIN="modem.my"/g' .config


# Add Argon Theme
#pushd package
#git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
#popd


# Modify default theme
#pushd feeds/luci/collections/luci
#sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' Makefile
#popd
#pushd package/feeds/luci/luci
#sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' Makefile
#popd


# Add Edge Theme
#pushd package
#git clone --depth=1 https://github.com/garypang13/luci-theme-edge.git
#popd
#echo 'CONFIG_PACKAGE_luci-theme-edge=y' >> .config


#Remove Passwall Geo-Data
#pushd feeds/xiao/luci-app-passwall
#sed -i 's/+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/#+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/g' Makefile
#popd


# Add luci-app-vssr
#pushd package
#git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
#git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr
#popd
#echo 'CONFIG_PACKAGE_luci-app-vssr=y' >> .config


# Add OpenClash
#pushd package
#git clone --depth=1 -b master https://github.com/vernesong/OpenClash
#popd
#echo 'CONFIG_PACKAGE_luci-app-openclash=y' >> .config


# Add library dependencies for Passwall
#pushd package
#git clone https://github.com/kenzok8/small.git
#popd

# Add redsocks dependency for Passwall
#pushd package 
#svn co https://github.com/kenzok8/openwrt-packages/trunk/redsocks2
#popd


#Add SSR Plus
#pushd package
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-ssr-plus
#popd
#echo 'CONFIG_PACKAGE_luci-app-ssr-plus=y' >> .config


# enable zram-swap
echo 'CONFIG_PACKAGE_zram-swap=y' >> .config
echo 'CONFIG_PACKAGE_kmod-zram=y' >> .config
echo 'CONFIG_PROCD_ZRAM_TMPFS=y' >> .config


# Update Version
echo -e '\nGiGaWRT By GilaGajet\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='[V21.02.0-RC3]'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWRT By GilaGajet $(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release


# Update TimeZone
#sed -i 's/UTC/Asia\/Kuala Lumpur/g' package/base-files/files/bin/config_generate
sed -i 's/0.openwrt.pool.ntp.org/time.google.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/time.cloudflare.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/clock.sjc.he.net/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/my.pool.ntp.org/g' package/base-files/files/bin/config_generate


# Update MOTD Banner
sed -i 's/Newifi D2/Dlink 842/g' files/etc/banner
echo -e "          Built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> files/etc/banner
