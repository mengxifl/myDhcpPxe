# pxe

## dhcp

### next-server

服务器用容器方式启动

#### 安装

```
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update && apk upgrade
apk add --no-cache kea-dhcp4
```

#### 配置文件

```json
# kea-dhcp.conf
{
  "Dhcp4":{
    "interfaces-config": {
      "interfaces": ["ens32"]
    },
    "client-classes": [
      {
        "name": "XClient_iPXE",
        "test": "substring(option[77].hex,0,4) == 'iPXE'",
        # set ipxe default start file
        "boot-file-name": "http://<ServerIP>:<ServerPort>/<path>/<PHPfile>"
      },
      {
        "name": "UEFI-32-1",
        "test": "substring(option[60].hex,0,20) == 'PXEClient:Arch:00006'",
        "boot-file-name": "ipxe-i386.efi"
      },
      {
        "name": "UEFI-32-2",
        "test": "substring(option[60].hex,0,20) == 'PXEClient:Arch:00002'",
        "boot-file-name": "ipxe-i386.efi"
      },
      {
        "name": "UEFI-64-1",
        "test": "substring(option[60].hex,0,20) == 'PXEClient:Arch:00007'",
        "boot-file-name": "ipxe-x86_64.efi"
      },
      {
        "name": "UEFI-64-2",
        "test": "substring(option[60].hex,0,20) == 'PXEClient:Arch:00008'",
        "boot-file-name": "ipxe-x86_64.efi"
      },
      {
        "name": "UEFI-64-3",
        "test": "substring(option[60].hex,0,20) == 'PXEClient:Arch:00009'",
        "boot-file-name": "ipxe-x86_64.efi"
      },
      {
        "name": "Legacy",
        "test": "substring(option[60].hex,0,20) == 'PXEClient:Arch:00000'",
        "boot-file-name": "undionly.kpxe"
      }
    ],
    "next-server": "192.168.200.10",
    "subnet4": [
      {
        "subnet": "192.168.200.0/24",
        "pools": [
          {
            "pool": "192.168.200.100 - 192.168.200.200"
          }
        ],
        "option-data": [
          {
            "name": "routers",
            "data": "192.168.200.2"
          },
          {
            "name": "domain-name-servers",
            "data": "8.8.8.8, 8.8.4.4"
          }
        ]
      }
    ]
  }
}
```

#### 启动命令

### TFTP

```
nerdctl run -it --rm -p 0.0.0.0:69:69/udp -v /home/pxe/tftp/:/tftpfile  alpine  /bin/sh
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update && apk upgrade
apk add --no-cache tftp-hpa bash
in.tftpd --ipv4 --address 0.0.0.0:69  -L -vv -s --secure -s  /tftpfile
```

