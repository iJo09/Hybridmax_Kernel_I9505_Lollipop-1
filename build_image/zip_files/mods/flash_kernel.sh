#!/sbin/sh
#
# This leverages the loki_patch utility created by djrbliss which allows us
# to bypass the bootloader checks on jfltevzw and jflteatt
# See here for more information on loki: https://github.com/djrbliss/loki
#
#
# Run loki patch on boot.img for locked bootloaders, found in loki_bootloaders
#

echo 'Flashing normally.'
dd if=/tmp/boot.img of=/dev/block/platform/msm_sdcc.1/by-name/boot || exit 1
exit 0
