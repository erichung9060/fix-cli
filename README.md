# fix

🛠️ A command-line fixing tool powered by Gemini AI — whenever you run a broken command, it helps you figure out the correct one!

## Features

- 🤖 Uses Gemini AI to analyze command errors and suggest fixes
- 🔄 Option to confirm before running the suggested fix
- 📝 Use the -e flag to get a detailed explanation of the issue
- 🗑️ Use the --uninstall flag to completely remove the tool
- ✅ Supports Linux and macOS


## Installation

1. First, you need a [Gemini API Key](https://makersuite.google.com/app/apikey)

2. Download and run the installation script:
```bash
curl -s -o install_fix-cli.sh https://raw.githubusercontent.com/erichung9060/fix-cli/refs/heads/main/install_fix-cli.sh && source install_fix-cli.sh
```

## Usage

1. When a command fails, just run:
```bash
fix
```

2. If you want a detailed explanation of the error, run:
```bash
fix -e
```

3. To uninstall the tool, run:
```bash
fix --uninstall
```

## Example

```bash
$ ifconfig
-bash: /usr/sbin/ifconfig: No such file or directory

$ fix
[fix] Asking Gemini for a fix...
[fix] Gemini suggests command: sudo apt-get update && sudo apt-get install net-tools
Execute the command? (y/n) y
[fix] Executing...
Get:1 https://dl.google.com/linux/chrome/deb stable InRelease [1825 B]
Hit:2 https://deb.nodesource.com/node_20.x nodistro InRelease                                       
Get:3 https://dl.google.com/linux/chrome/deb stable/main amd64 Packages [1217 B]
Hit:4 http://archive.ubuntu.com/ubuntu noble InRelease  
Fetched 3042 B in 1s (4967 B/s)
Reading package lists... Done
...
[fix] Execute original command? (y/n) y
[fix] Executing...
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:39:57:5e:67  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens18: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.2.2.226  netmask 255.255.252.0  broadcast 10.2.3.255
        inet6 fe80::be24:11ff:fe77:a44d  prefixlen 64  scopeid 0x20<link>
        ether bc:24:11:77:a4:4d  txqueuelen 1000  (Ethernet)
        RX packets 9270896  bytes 4069265448 (4.0 GB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8796796  bytes 3992005143 (3.9 GB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 5449409  bytes 926215140 (926.2 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 5449409  bytes 926215140 (926.2 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
