#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate


# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall
#sed -i 's/ upx\/host//g' openwrt-passwall/v2ray-plugin/Makefile
#grep -lr upx/host openwrt-passwall/* | xargs -t -I {} sed -i '/upx\/host/d' {}

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash


# Add luci-app-wrtbwmon
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-wrtbwmon
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/wrtbwmon

# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config

#-----------------------------------------------------------------------------

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


# Mod zzz-default-settings
#pushd package/lean/default-settings/files
#sed -i '/http/d' zzz-default-settings
#sed -i '/18.06/d' zzz-default-settings
#export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
#export date_version=$(date -d "$(rdate -n -4 -p pool.ntp.org)" +'%Y-%m-%d')
#sed -i "s/${orig_version}/${orig_version} ${date_version}/g" zzz-default-settings
#sed -i "s/zh_cn/auto/g" zzz-default-settings
#sed -i "s/uci set system.@system[0].timezone=CST-8/uci set system.@system[0].hostname=Mi4AG\nuci set system.@system[0].timezone=MYT-8/g" zzz-default-settings
#sed -i "s/Shanghai/Kuala Lumpur/g" zzz-default-settings
#popd

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

#-----------------------------------------------------------------------------

# Update Version
sed -i 's/Newifi D2/Mi 4A Gigabit/g' files/etc/banner
echo -e "          Built on "$(date +%Y.%m.%d)"\n -----------------------------------------------------" >> files/etc/banner

sed -i "s/OpenWrt /GilaGajet build $(TZ=UTC+8 date "+%Y.%m.%d") @ OpenWrt /g" package/base-files/files/etc/banner

# Enable WiFi Interface
sed -i 's/wireless.radio${devidx}.disabled=1/wireless.radio${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify hostname
sed -i 's/OpenWrt/Mi4AG/g' package/base-files/files/bin/config_generate

# Add kernel build user
sed -i 's/CONFIG_KERNEL_BUILD_USER=""/CONFIG_KERNEL_BUILD_USER="gilagajet"/g' .config


# Add kernel build domain
sed -i 's/CONFIG_KERNEL_BUILD_DOMAIN=""/CONFIG_KERNEL_BUILD_DOMAIN="modem.my"/g' .config

# Update TimeZone
sed -i 's/0.openwrt.pool.ntp.org/time.google.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/time.cloudflare.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/clock.sjc.he.net/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/my.pool.ntp.org/g' package/base-files/files/bin/config_generate

############REMOVE LEDE CONFIG############

# Add zram-swap
echo 'CONFIG_PACKAGE_zram-swap=y' >> .config
echo 'CONFIG_PACKAGE_kmod-zram=y' >> .config
echo 'CONFIG_PROCD_ZRAM_TMPFS=y' >> .config


# Add stunnel
echo 'CONFIG_PACKAGE_stunnel=y' >> .config


#test
echo 'CONFIG_PACKAGE_px5g-wolfssl=y' >> .config
echo 'CONFIG_PACKAGE_htop=y' >> .config
