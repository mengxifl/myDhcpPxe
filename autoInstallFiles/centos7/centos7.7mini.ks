#vim test.sh 需要设置一下
#:set ff?
#:set fileformat=unix
#:wq


#platform=x86, AMD64, 或 Intel EM64T
#version=DEVEL

# Install OS instead of upgrade

install

# Keyboard layouts

keyboard 'us'

# Root password

rootpw --plaintext 1234qwer!

# System language

lang zh_CN

# System authorization information

auth  --passalgo=sha512

# Use text mode install

#text/graphical 如果是text就是可以看到日志模式 graphical 能看到进度


graphical

# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx


# Firewall configuration
firewall --disabled
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# Use network installation
url --url=http://10.130.147.239/autoinstallfiles/linux/centos7/os/1908/
#url --url=http://10.130.147.239/centos7/installfiles/

# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --asprimary --fstype="xfs" --size=500
part / --asprimary --fstype="xfs" --grow --size=1

%packages
@core
-NetworkManager
-NetworkManager-team
-NetworkManager-tui
-aic94xx-firmware
-alsa-firmware
-biosdevname
-dracut-config-rescue
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl105-firmware
-iwl135-firmware
-iwl2000-firmware
-iwl2030-firmware
-iwl3160-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6000g2b-firmware
-iwl6050-firmware
-iwl7260-firmware
-iwl7265-firmware
-kernel-tools
-libsysfs
-linux-firmware
-lshw
-microcode_ctl
-postfix
-sg3_utils
-sg3_utils-libs
%end

%post --erroronfail

nextserver=`cat /etc/resolv.conf | tail -1 | awk '{print $2}'`
echo ${nextserver%$'\r'}
echo "------------------------"
scriptserver=`cat /etc/resolv.conf | tail -2 | head -n 1 | awk '{print $2}'`
echo ${scriptserver%$'\r'}
if [[ ${scriptserver%$'\r'} == "The" ]]; then
    scriptserver=`echo ${nextserver%$'\r'}`
fi
echo "------------------------"
encodeSN=`dmidecode -t 1 | grep "Serial Number" | awk -F ": " '{print $2}' | sed 's, ,%20,g'`
echo ${encodeSN%$'\r'}
echo "------------------------"
ip=`ip addr show | grep "inet" | grep -v "inet6" | grep -v "docker" | grep -v "127" | awk '{print $2}' | awk -F "/" '{print $1}'`
echo ${ip%$'\r'}
echo "------------------------"
URL=`echo 'http://'${nextserver%$'\r'}':8082/finshinstallOS?sn='${encodeSN%$'\r'}'&ip='${ip%$'\r'}'&scriptserver='${scriptserver%$'\r'}'&os=centos7&key=G17zMorqUfXLCnDt'`
CoverURL=${URL%$'\r'}
echo ${CoverURL%$'\r'}
curl ${CoverURL%$'\r'}


%end