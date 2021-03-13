#!/bin/bash

DIR="$(pwd)"

# Create SquashFS, replace existing file in /iso/binary/live/
rm -rf $DIR/iso/binary/live/filesystem.squashfs
cd iso
sudo mksquashfs chroot $DIR/iso/binary/live/filesystem.squashfs -comp xz -e boot

# Generate the ISO, the example names get mapped to their roles here, https://wiki.debian.org/RepackBootableISO
# Extract MBR template file to disk
orig_iso=$DIR/iso/live-image-amd64.hybrid.iso
new_files=$DIR/iso/
new_iso=$DIR/iso/live-image-amd64-modified.hybrid.iso
mbr_template=isohdpfx.bin # This template file will be created in /iso/ This enables booting from USB stick 
dd if="$orig_iso" bs=1 count=432 of="$mbr_template"

# Create the new ISO image, this info comes from inside the iso : /.disk/mkisofs => mount the iso to extract this info.
sudo xorriso \
	-as mkisofs -R -r -J -joliet-long -l -cache-inodes -iso-level 3 \
	-isohybrid-mbr isohdpfx.bin \
	-partition_offset 16 -A "skynet" -p "grotius" -publisher "grotius" -V "skynet" \
	--modification-date=2021031214394100 -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
	-boot-load-size 4 \
	-boot-info-table \
	-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -o live-image-amd64.hybrid-modified.iso binary
