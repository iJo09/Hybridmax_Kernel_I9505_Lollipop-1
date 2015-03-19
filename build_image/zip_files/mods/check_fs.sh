#!/sbin/sh

mount > /tmp/mount.txt
CACHE=`cat /tmp/mount.txt | grep "cache" | grep "f2fs"`
SYSTEM=`cat /tmp/mount.txt | grep "system" | grep "f2fs"`

if [ "${CACHE}" == "" ];
then
	echo "Found ext4 system, nothing to do here..."
else
	echo "Found f2fs system..."
	echo "Unpacking boot image..."
	/tmp/unpackbootimg -i /tmp/boot.img -o /tmp/

	echo "Unpacking ramdisk..."
	mkdir /tmp/ramdisk
	cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
	cd /tmp/ramdisk/
	gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
	cd /

	echo "Found ROM..."
	if [ "${SYSTEM}" == "" ];
	then
		echo "Replace fstab for /cache and /data..."
		rm /tmp/ramdisk/fstab.qcom
		cp /tmp/fstab.qcom /tmp/ramdisk/fstab.qcom
		cp /tmp/init.target.rc /tmp/ramdisk/init.target.rc
	else
		echo "Replace fstab for /cache and /data and /system..."
		rm /tmp/ramdisk/fstab.qcom
		cp /tmp/fstab_sys.qcom /tmp/ramdisk/fstab.qcom
		cp /tmp/init.target.sys.rc /tmp/ramdisk/init.target.rc
	fi
		
	echo "Repacking ramdisk..."
	rm /tmp/ramdisk/boot.img-ramdisk.gz
	rm /tmp/boot.img-ramdisk.gz
	cd /tmp/ramdisk/
	find . | cpio -o -H newc | gzip > ../boot.img-ramdisk.gz
	cd /
	
	echo "Remaking boot.img..."
	/tmp/mkbootimg.sh
	rm /tmp/boot.img
	cp /tmp/newboot.img /tmp/boot.img
	rm /tmp/newboot.img
fi

