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


# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate


# Enable WiFi Interface
sed -i 's/wireless.radio${devidx}.disabled=1/wireless.radio${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# Add luci-app-passwall
pushd package
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall
popd
echo 'CONFIG_PACKAGE_luci-app-passwall=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Dns2socks=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple-obfs=y' >> .config
echo 'CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y' >> .config


#Remove Passwall Geo-Data
pushd package/openwrt-passwall/luci-app-passwall
sed -i 's/+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/#+PACKAGE_$(PKG_NAME)_INCLUDE_Xray:xray-geodata/g' Makefile
popd


#Copy custom folder
#cp -r $GITHUB_WORKSPACE/files/ files


# Modify hostname
sed -i 's/OpenWrt/Mi4AG/g' package/base-files/files/bin/config_generate


# Add kernel build user
sed -i 's/CONFIG_KERNEL_BUILD_USER=""/CONFIG_KERNEL_BUILD_USER="gilagajet"/g' .config


# Add kernel build domain
sed -i 's/CONFIG_KERNEL_BUILD_DOMAIN=""/CONFIG_KERNEL_BUILD_DOMAIN="modem.my"/g' .config


# Add Argon Theme
pushd package
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
popd
echo 'CONFIG_PACKAGE_luci-theme-argon=y' >> .config


# Enable Argon Config
#pushd package
#git clone --depth=1 https://github.com/kenzok8/openwrt-packages/tree/master/luci-app-argon-config
#popd
#echo 'CONFIG_PACKAGE_luci-app-argon-config=y' >> .config


# Modify default theme
pushd feeds/luci/collections/luci
sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' Makefile
popd
pushd package/feeds/luci/luci
sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' Makefile
popd

# Add Edge Theme
pushd package
git clone --depth=1 https://github.com/garypang13/luci-theme-edge.git
popd
echo 'CONFIG_PACKAGE_luci-theme-edge=y' >> .config


echo -e '\nOpenwRT By GilaGajet\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='[v19.07.7-BETA]'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWRT By GilaGajet $(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release


# Update TimeZone
#sed -i 's/UTC/Asia\/Kuala Lumpur/g' package/base-files/files/bin/config_generate
sed -i 's/0.openwrt.pool.ntp.org/time.google.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/time.cloudflare.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/clock.sjc.he.net/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/my.pool.ntp.org/g' package/base-files/files/bin/config_generate


# Update MOTD Banner
sed -i 's/Newifi D2/Mi 4A Gigabit/g' files/etc/banner
echo -e "          Built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> files/etc/banner
