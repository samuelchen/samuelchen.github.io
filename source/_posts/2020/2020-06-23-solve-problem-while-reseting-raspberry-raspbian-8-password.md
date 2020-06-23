---
title: 解决重设树莓派 Raspbian 8 密码碰到的问题
slug: solve-problem-while-reseting-raspberry-raspbian-8-password
categories:
  - Utility
tags:
  - RaspBerry
  - Raspbian
  - reset
comments: true
draft: 解决重设树莓派 Raspbian 8 密码碰到的问题
date: 2020-06-23 17:43:14
updated:
id: solve-problem-while-reseting-raspberry-raspbian-8-password
---


最近想把吃灰的`树莓派3B`拿出来用用，接通后却发现忘了密码，于是这网上找了些方法重置。

基本上都是这个步骤

1. SD卡拿电脑上修改`cmdline.txt`，应该只有一行，在最后加上` init=/init/sh`，启动中途进入`shell`，也有用`bash`的。
2. SD卡插回树莓派，插电启动，然后等命令行输入：
	```sh
	mount -o remount, rw /
	passwd pi
	```
	其中第一行是重新挂载，第二行是修改密码。
3. 同步并初始化
	```sh
	sync
	exec /sbin/init
	```
4. 关机 `sudo halt`
5. 编辑 `cmdline.txt` 去掉刚加入的内容。

然后就可用正常启动了。

实际上，在重置的过程中，可能因为不同系统版本的原因，发生各种问题，如无法挂载，无法修改密码等。下面记录下碰到的问题及解决办法：

1. `mount -o remount, rw /` 命令报错 `mount: /: mount failed Unkown error -1`
   
   原因是启动的是`shell`不是`bash`，命令格式不同，在bash里正常，这里 `remount,` 和 `rw` 之间**不要空格**。

2. mount 错误 `mount: can't find PARTUUID=c903fbc0-02`

	原因是UUID对应分区无法找到。先查看fstab（非必须） `cat /etc/fstab`，可用看到这个UUID对应的就是`/`。然后 `ls /dev/mmcblk*` 查看所有 mmc block 分区，可用看到对应的 `/dev/mmcblk0p2`。 最后，解决办法是，直接使用分区设备挂载 `mount -o remount,rw /dev/mmcblk0p2 /`

3. 修改密码时报错，`Authentication token manipulation error`。这是因为没有重新挂载，还是只读的原因，挂载成功就没这个问题。


--- END ---
