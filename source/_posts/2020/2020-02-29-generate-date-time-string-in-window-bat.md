---
title: Window 批处理(BAT)中生成格式化日期时间字符串
categories: Programming
tags:
  - bat
  - Windows
  - datetime
  - string
date: 2020-02-29 00:36:31
updated:
id: generate-date-time-string-in-window-bat
---

今天打算写一些脚本同时支持 Windows 和 Linux，因此需要同一个脚本需要写一个 shell 版本和一个 `bat` 版本。其中一项需求是要生成一个日志文件，文件后缀是当前系统时间的字符串'yyymmddMMHHSS'这种格式的，所以需要取到当前时间并格式化。在 Linux 中，这是一个很简单的需求，直接使用 `date +'%y%m%d%H%M%S'` 就可以拿到，但是在 Windows 中就非常麻烦了。

<!--more-->

在 Windows 中，最直接的想法是和 Linux 类似，使用 `date /t` 和 `time /t` 命令来获取，然后利用
`%date:~0,4%` 来取到年份（`%:~0,4%` 是 bat 取子字符串语法，表示取 0 到 4 个字符，前开后闭），
其他分别取到月、日、小时、分钟和秒，最后组合。完整的例子如下.

`%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%`

这个例子**基本上**是可以工作的。但为什么说“基本上”？因为这个方法只能适用于部分系统，没有考虑区域(locale)。

由于 `Windows` 有区域和格式设定，所以 `date` 和 `time` 命令显示出来时间格式是经过格式化的，换
句话说，不同的区域由于设置的时间格式不同，返回的格式串就不同。比如中国/中文，经常使用 `2020-02-02`
这种格式，而欧美/英文，经常使用 `02/02/20` 这种格式。所以上面那个在英文系统下，多半显示不对。

也在网上找了些例子，有些考虑到了不同的格式，但也是用 `date` 各种判断拼凑出来，也有提到
直接访问 CMOS 硬件 clock 的方法，都是非常麻烦，不太适用于写短小的`bat`批处理文件。

最终，找到了一个**比较好**的办法，那就是利用 `WMI` 的接口来直接获得时间。说说它比“比较好”的原因是
因为 `WMI` 的接口不一定每个机器都有，这个命令也是处于`deprecated`即将退休的状态。

```bat
@echo off
rem set local ENABLEDELAYEDEXPANSION

wmic /? >> nul|| echo "wmic not found." && echo 'quit'

for /f %%i in ( 'wmic os get LocalDateTime /value' ) do (
    echo "%%i" | findstr "LocalDateTime" > nul && set DT=%%i
)
set DT=%DT:~14,14%
rem echo "%DT%"
```

此外，利用 `PowerShell` 也是一个**比较好**的办法，问题同样是可能有些机器没装。如果想处理时区信息，
可以使用 `tzinfo` 命令。

总之，根据自身需求和环境，选择合适的方法。


--- END ---
