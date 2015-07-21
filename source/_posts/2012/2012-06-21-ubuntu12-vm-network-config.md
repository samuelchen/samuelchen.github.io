title: Ubuntu12 虚拟机网络配置
tags:
  - Article
  - Config
  - Linux
  - Ubuntu
  - VM
  - Network
id: 188
categories:
  - System
date: 2012-06-21 19:09:05
---

用VM Player 4.0装了Ubuntu 12 server，然后复制了几个组成局域网来使用，发现了一些问题，网上基本上找不到完整的解决方法，这里记录下来。

<!-- more -->

```
在后来的实际应用中，了解了更多的方法，这种方法并不是一个比较好的方法，但仍不失为一个简单有效的方法。
```


## Mac 地址

复制的虚机Mac 地址都是相同的，组网会有问题，所以需要改过来。

首先是修改VM Setting，可以生成一个新的Mac地址，把它记录下来，假设是
`00:AA:BB:CC:DD:EE` 。
网上的方法主要是
<pre class="lang:default decode:true">sudo ifconfig eth0 down  #停掉网卡
sudo ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE   #改mac
sudo ifconfig eth0 up     #起网卡
sudo /etc/init.d/networking restart  #重启网络</pre>
但是，这样是不成的（至少在这次），重启以后会失效，又变回原来的。网上给出的方案是在 `/etc/network/if-pre-up.d/` 中添加
`ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE`，但我试过了是不行的。
另外有一种方法就是修改 `/etc/rc.local` 每次启动修改，但这种方法不太爽。
所以，最终的方案是：在 VM Setting 中删除掉 Network Adpater，然后再重启重新添加一个。
就这么简单，思路别被局限了。

<!--more-->

## 机器名

复制以后的机器，名字都是一样，打算取名为vm-ubuntu1, vm-ubuntu2, vm-ubuntu3... 所以得逐个修改。

首先 `hostname vm-ubuntu2` 是不能保存的，重启后又还原，所以得修改`/etc/hostname`，内容就一行，`vm-ubuntu2`

其次，光改了名字，从其他的机器是ping不到的，所以我们需要修改 `/etc/hosts` 来把所有的机器都列出来。
<pre class="lang:default decode:true" title="hosts">127.0.0.1   localhost
192.168.48.142  vm-ubuntu1
192.168.48.156  vm-ubuntu2
192.168.48.148  vm-ubuntu3</pre>
将 hosts 文件复制到所有的虚拟机（你也可以使用rsync同步），这样就可以通过名字互通了。

## 静态IP

上面这样做了之后，会有一个问题，就是DHCP重启之后IP会变，名字就失效了，所以需要改成静态IP。
很简单，先 ifconfig 查看一下 当前的 网关和掩码，
<pre class="lang:default decode:true">Link encap:Ethernet  HWaddr 00:0c:29:1f:2a:fc
          inet addr:192.168.48.142  Bcast:192.168.48.255  Mask:255.255.255.0</pre>
网关是 `192.168.48.255`， 掩码是 `255.255.255.0`，同时可以看到Mac已经变了(HWaddr就是）

然后修改 `/etc/network/interfaces` 就可以了，
<pre class="lang:default decode:true">auto eth0
iface eth0 inet dhcp</pre>
改为
<pre class="lang:default decode:true">auto eth0
iface eth0 inet static
address 192.168.48.100
netmask 255.255.255.0
gateway 192.168.48.255</pre>
这儿有个陷阱，就是 VM 的 网关实际上并不是 192.168.xx.255，而是window下看到的 VMware Network Adapter VMnet8 的 IP，一般是 192.168.xx.2，可以尝试 192.168.xx.1 或者 192.168.xx.2，所以真实的应该是
<pre class="lang:default decode:true">auto eth0
iface eth0 inet static
address 192.168.48.101
netmask 255.255.255.0
gateway 192.168.48.2</pre>
注意：我们不要使用192.168.xx.1 或者 2 来作为虚机的IP，这些都保留了，安全起见，用100之后的。
最后 sudo reboot，重启之后就可以联网了。

## DNS 域名解析

上面设好了后，内网基本没问题，但是连外网可能会碰到问题，域名解析不了（我碰到了），所以需要设置DNS。
网上的方法，有一种是修改 `/etc/network/interfaces` 加上 nameserver
<pre class="lang:default decode:true">auto eth0
iface eth0 inet static
address 192.168.48.101
netmask 255.255.255.0
gateway 192.168.48.2
nameserver 8.8.8.8</pre>
这个貌似没有用，最后有用的方法是，修改 `/etc/resolveconf/resolve.conf.d/base`，加上 nameserver 就可以了
<pre class="lang:default decode:true">nameserver 192.168.48.2
nameserver 8.8.8.8
nameserver 8.8.4.4</pre>
- END
