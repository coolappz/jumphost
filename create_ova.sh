#!/bin/bash

NAME="Jumphost-v1.0"
URL="https://sourceforge.net/projects/linuxvmimages/files/VirtualBox/D/10/Debian_10.6.0_VB.zip/download"
ZIPNAME="Debian.zip"
OVANAME="Debian_10.6.0_VB_LinuxVMImages.com.ova"

if [ -f $OVANAME ]; then
	echo "OVA already downloaded"
else
	wget -O $ZIPNAME $URL
	unzip $ZIPNAME
fi
vboxmanage controlvm $NAME poweroff
VBoxManage unregistervm $NAME --delete
VBoxManage import $OVANAME --vsys 0 --vmname $NAME -eula accept --unit 15 --ignore
vboxmanage modifyvm $NAME --nic1 nat
VBoxManage modifyvm $NAME --natpf1 delete guestssh
VBoxManage modifyvm $NAME --natpf1 "guestssh,tcp,,2222,,22"
VBoxManage modifyvm $NAME --natpf2 delete guestrdp
VBoxManage modifyvm $NAME --natpf2 "guestrdp,tcp,,3389,,3389"
vboxmanage startvm $NAME --type headless


