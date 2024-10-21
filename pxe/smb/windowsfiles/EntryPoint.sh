#!/bin/bash

sed -i 's,sharedir,'${SHARDDIR}',' ${CONFIGFILE} /etc/samba/smb.conf
useradd -M -s /sbin/nologin ${USERNAME}

passwd ${USERNAME} << input

${PASSWORD}
${PASSWORD}

input

smbpasswd -a ${USERNAME}
groupadd ${GRPUPNAME}
usermod -aG ${GRPUPNAME} ${USERNAME}
chgrp -R ${GRPUPNAME} ${SHARDDIR}

smbd -s ${CONFIGFILE} -i -S
smbclient -U shareuser //192.168.11.10/share

for arg; do
	allarg=$allarg" $arg" 
done


sleep 300000
#smbd -s ${CONFIGFILE} -i -S$allarg