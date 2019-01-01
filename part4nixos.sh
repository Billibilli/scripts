#!/bin/sh
# https://unix.stackexchange.com/questions/343632/uefi-chainloading-grub-from-grub
# https://nixos.org/nixos/manual/
# https://serverfault.com/questions/258152/fdisk-partition-in-single-line
# https://serverfault.com/questions/250839/deleting-all-partitions-from-the-command-line
# https://nixos.wiki/wiki/Bootloader
# https://www.reddit.com/r/NixOS/comments/2bvgr4/nixos_dual_boot_grub_setup/
# https://www.gnu.org/software/grub/manual/grub/html_node/Multi_002dboot-manual-config.html
# https://nixos.org/nix-dev/2015-August/017955.html
# https://www.reddit.com/r/linuxquestions/comments/2wm7oq/help_manually_booting_from_grub_console_into/cp0mqlc/
# https://unix.stackexchange.com/questions/279856/nixos-installation-on-multi-boot-system-with-grub-from-arch-installation
# https://unix.stackexchange.com/questions/343632/uefi-chainloading-grub-from-grub


# Usage checking
if [ -z "$1" ]; then
	echo 'Usage:source part4nixos.sh </dev/stuff>'
	return 1
fi

# Application Checking
# command -v parted >/dev/null && echo "asd" || { echo "d" && return 1}
 

# DRIVE
DRIVE=$1

# Maybe we can do something to safe-guard installation
# Check space or some-sort 
udevadm info --query=all -n $DRIVE

# Check current boot mode
if [ -d /sys/firmware/efi/efivars ]; then
	BOOT_MODE="UEFI"
else
	BOOT_MODE="Legacy"
fi

# Check
if [ "$BOOT_MODE" = "UEFI" ]; then
	echo "We have UEFI"
	# mkpart： https://www.gnu.org/software/parted/manual/html_node/mkpart.html
	# 1. Create a GPT partition table. 
	# parted $DRIVE -- mklabel gpt
	# 2. Add the root partition. This will fill the disk except for the end part, where the swap will live, and the space left in front (512MiB) which will be used by the boot partition. 
	# parted $DRIVE -- mkpart primary 512MiB -8GiB
	# 3. Next, add a swap partition. The size required will vary according to needs, here a 8GiB one is created.
	# parted $DRIVE -- mkpart primary linux-swap -8GiB 100%
	# parted $DRIVE -- mkpart ESP fat32 1MiB 512MiB
	# parted $DRIVE -- set 3 boot on
else
	echo "We have Legacy"
fi


