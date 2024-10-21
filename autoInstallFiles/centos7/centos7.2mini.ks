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
url --url=http://10.130.147.239/autoinstallfiles/linux/centos7/os/1511/
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