#!/bin/sh
VMNAME="virtserver"
ISO="/home/cuahutli/Descargas/elementary-0.4.iso"
VBOX_PATH="/home/cuahutli/VirtualBox VMs/"
DIR_VM="$VBOX_PATH""$VMNAME"
HDD_VM="$DIR_VM/$VMNAME-disk1.vmdk"
echo "Creando directorio que almacenara la VM"
mkdir -p "$DIR_VM"

VBoxManage createvm -name "$VMNAME" --register --ostype Ubuntu_64

#RAM Memory
VBoxManage modifyvm "$VMNAME" --memory 1024

#Network
VBoxManage modifyvm "$VMNAME" --nic1 bridged --bridgeadapter1 eth0

#Storage
VBoxManage storagectl "$VMNAME" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storagectl "$VMNAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storagectl "$VMNAME" --name "SCSI Controller" --add scsi --controller LsiLogic

VBoxManage createhd --filename "$HDD_VM" --size 20000 --format VMDK #--variant Split2G
#VBoxManage createvdi --filename "disk2.vdi" --size 1000

VBoxManage storageattach "$VMNAME" --storagectl "IDE Controller" --type dvddrive --port 0 --device 0 --medium "$ISO"
VBoxManage storageattach "$VMNAME" --storagectl "SATA Controller" --type hdd --port 0 --device 0 --medium "$HDD_VM"
#VBoxManage storageattach "$VMNAME" --storagectl "SCSI Controller" --type hdd --port 0 --device 0 --medium "disk2.vdi"


#Activate VRDE
VBoxManage modifyvm "$VMNAME" --vrde on
VBoxManage modifyvm "$VMNAME" --vrdeport 5050
VBoxManage modifyvm "$VMNAME" --vrdemulticon on


#VBoxManage showvminfo centos
#VboxHeadless -startvm "$VMNAME" &
#VBoxManage controlvm "$VMNAME" poweroff
