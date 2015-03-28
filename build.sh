#!/bin/bash
# kernel build script by Hybridmax

BUILD_USER="$USER"
DATE="`date +"%d-%m-%Y"`"
TIME="`date +"%T"`"
KERNEL_DIR="$PWD"
BUILD_USER="$USER"
TOOLCHAIN_DIR=/home/hybridmax/android/toolchains

# Toolchains

#Sabermod
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/sm-arm-eabi_4.7/bin/arm-eabi-
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/sm-arm-eabi_4.9/bin/arm-eabi-
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/sm-arm-eabi_4.10/bin/arm-eabi-

#Linaro
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/linaro_4.7.4_arm-cortex-a15/bin/arm-cortex_a15-linux-gnueabihf-
BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/linaro_4.9_arm-cortex-a15/bin/arm-cortex_a15-linux-gnueabihf-
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/linaro_4.9_arm-cortex-linux/bin/arm-cortex-linux-gnueabi-

#HRT Linaro
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/hrt-arm-eabi-4.9/bin/arm-eabi-

#Stock
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/arm-eabi_4.7/bin/arm-eabi-
#BUILD_CROSS_COMPILE=$TOOLCHAIN_DIR/arm-eabi_4.8/bin/arm-eabi-


BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`
KERNEL_DEFCONFIG=jf_defconfig
USER_DEFCONFIG=0hybridmax_jf_defconfig
VARIANT_DEFCONFIG=jf_eur_defconfig
SELINUX_DEFCONFIG=selinux_defconfig


BUILD_KERNEL()
{	
	echo ""
	echo "=============================================="
	echo "START: MAKE CLEAN"
	echo "=============================================="
	echo ""

	make clean
        rm -rf .version
        rm arch/arm/boot/dts/*.dtb

	echo ""
	echo "=============================================="
	echo "END: MAKE CLEAN"
	echo "=============================================="
	echo ""

	echo "CPU"
	echo "$BUILD_JOB_NUMBER"
	echo "BUILD USER"
	echo "$BUILD_USER"
	echo "TOOLCHAIN"
	echo "$BUILD_CROSS_COMPILE"
	
	
	echo ""
	echo "=============================================="
	echo "START: BUILD_KERNEL"
	echo "=============================================="
	echo ""

        export ARCH=arm
        export SUBARCH=arm
        export USE_SEC_FIPS_MODE=true
        export KCONFIG_NOTIMESTAMP=true
#       export ENABLE_GRAPHITE=true 
        export CROSS_COMPILE=$BUILD_CROSS_COMPILE
        make $USER_DEFCONFIG VARIANT_DEFCONFIG=$VARIANT_DEFCONFIG SELINUX_DEFCONFIG=$SELINUX_DEFCONFIG
        make -j$BUILD_JOB_NUMBER

	echo ""
	echo "================================="
	echo "END: BUILD_KERNEL"
	echo "================================="
	echo ""
}





# MAIN FUNCTION
rm -rf ./build.log
(
	START_TIME=`date +%s`
	BUILD_DATE=`date +%m-%d-%Y`
	BUILD_KERNEL


	END_TIME=`date +%s`

	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1	 | tee -a ./build.log



# Credits:
#
# This File uses commands of Developers below. If you use this file give Credits to the Developer and 
# tell his name at the bottom of this Credits Section!
#
# Samsung
# google
# osm0sis
# cyanogenmod
# kylon
# thehacker911
