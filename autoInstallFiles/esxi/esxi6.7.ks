# Accept the VMware End User License Agreement
vmaccepteula

# Set the root password for the DCUI and Tech Support Mode
rootpw P@55w0rd

clearpart --alldrives --overwritevmfs

# Install on the first local disk available on machine
install --firstdisk --overwritevmfs

# Set the network to DHCP on the first network adapter
#network --bootproto=dhcp --device=vmnic0
#network --bootproto=static --device=vmnic0 --ip=192.168.148.100 --netmask=255.255.252.0 --gateway=192.168.148.1


# Reboot after finish installation
reboot
