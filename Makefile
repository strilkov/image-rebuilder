WORKDIR=iso/
MOUNTDIR=mnt/
IMAGE=original.iso
CUSTOM=custom.iso

.PHONY: fetch unpack pack

fetch:
	wget http://releases.ubuntu.com/16.04.2/ubuntu-16.04.2-server-amd64.iso
	mv *.iso original.iso

unpack:
	rm -rf $(WORKDIR)
	mkdir -p $(WORKDIR)
	mkdir -p $(MOUNTDIR)
	sudo mount -o loop $(IMAGE) $(MOUNTDIR)
	rsync -av $(MOUNTDIR) $(WORKDIR)
	sudo umount $(MOUNTDIR)
	chmod -R u+w $(WORKDIR)

pack:
	rm -f $(CUSTOM)
	mkisofs -r -V "Ubuntu custom install" \
		-cache-inodes \
		-J -l -b isolinux/isolinux.bin \
		-c isolinux/boot.cat -no-emul-boot \
		-boot-load-size 4 -boot-info-table \
		-input-charset utf-8 \
		-o $(CUSTOM) $(WORKDIR)
