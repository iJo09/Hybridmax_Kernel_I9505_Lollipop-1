#!/bin/bash

KERNEL_NAME=Hybridmax_Kernel_TWLP
KERNEL_DIR=/home/hybridmax/android/kernel/s4/s4tw
REPACK_DIR=build_image/tw-5.0
BUILD=build_image
ZIP_FILES=zip_files
MODULES=$BUILD/$ZIP_FILES/system/lib/modules
ZIMAGE=arch/arm/boot/zImage
OUTPUT_DIR=$KERNEL_DIR/$BUILD/output_kernel

REPACK_KERNEL()
{
        echo ""
	echo "=============================================="
	echo "START: REPACK_KERNEL"
	echo "=============================================="
	echo ""

        rm -rf $OUTPUT_DIR/Hybridmax_*
        rm -rf $OUTPUT_DIR/Hybridmax*
        echo "Making boot.img"
	cp $ZIMAGE $REPACK_DIR/zImage
	find . -name "*.ko" -exec cp {} $KERNEL_DIR/$MODULES \;
	cd  $REPACK_DIR
	../mkbootfs ./ramdisk | gzip > ramdisk.gz

../mkbootimg --kernel zImage --ramdisk ramdisk.gz --cmdline "console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3" -o boot.img --base "0x80200000" --ramdiskaddr "0x82200000"

	mv -f boot.img $KERNEL_DIR/$BUILD/$ZIP_FILES
	echo "Making zip"
	cd ../$ZIP_FILES
	zip -r $KERNEL_NAME.zip META-INF mods system data boot.img
        mv $KERNEL_NAME.zip $OUTPUT_DIR
        cd ..
        echo "Making Cleaning..."
	rm -rf $KERNEL_DIR/$REPACK_DIR/zImage
	rm -rf $KERNEL_DIR/$REPACK_DIR/ramdisk.gz
        rm -rf $KERNEL_DIR/$MODULES/*
        rm -rf $KERNEL_DIR/$BUILD/$ZIP_FILES/boot.img

	echo ""
	echo "=============================================="
	echo "END: REPACK_KERNEL"
	echo "=============================================="
	echo ""

}




# MAIN FUNCTION
rm -rf ./build.log
(
        START_TIME=`date +%s`
        BUILD_DATE=`date +%m-%d-%Y`
        REPACK_KERNEL
        END_TIME=`date +%s`
        let "ELAPSED_TIME=$END_TIME-$START_TIME"
        echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1 | tee -a ./build.log


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
