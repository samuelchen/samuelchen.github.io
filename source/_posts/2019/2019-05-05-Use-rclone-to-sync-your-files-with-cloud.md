---
title: 使用 rclone 同步云端和本地文件
date: 2019-05-05 15:11:18
updated:
categories: Cloud2End
tags:
  - Azure
  - rsync
  - blob
  - static
  - deployment
  - synchronization
comments: true
---

之前在[这篇blog](/Deploy-Hexo-static-website-on-Azure-Blob-storage/)中介绍过使用Azure Client `az` 来部署生成到网站. 
使用`az`很方便，但是也有些缺点，例如会把整个网站全部重新上传一遍，速度慢不说，还浪费多次`blob`的操作。

后来找到了另外一个工具`rclone`（[下载、安装、文档](https://rclone.org)，或使用各平台包管理器安装），
它可以像`rsync`一样同步本地和远端文件，只更新变化过的文件。

使用起来也很简单， 首先新建一个远端配置`rclone config`，根据提示，输入名字，类型，account 或者 
connection string。例如，我配置 `azure-chen` 这个名字（本地名称）对应 azure 上 `chen` 这个 blob 账号。

然后就可以使用了：

```sh
# 列出远端容器
rclone lsd azure-chen:

          -1 2019-04-12 13:09:50        -1 $web
		  
# 列出容器中文件
rclone ls azure-chen:\$web

    11965 404.html
	...
	...
    42150 all-tags/index.html
    12676 archives/2011/03/index.html
    12150 archives/2011/04/index.html
    10677 archives/2011/06/index.html
    17724 archives/2011/index.html
    10626 archives/2012/03/index.html
    10316 archives/2012/06/index.html
    12050 archives/2012/index.html
    10429 archives/2014/04/index.html
    10424 archives/2014/index.html
    10545 archives/2017/12/index.html
    10539 archives/2017/index.html
    10792 archives/2018/11/index.html
    10786 archives/2018/index.html
    10715 archives/2019/04/index.html
    10710 archives/2019/index.html
    26245 archives/index.html
    10983 archives/page/2/index.html
    28747 assets/css/font-awesome.css
      735 assets/css/jquery.fancybox-thumbs.css
     4955 assets/css/jquery.fancybox.css
    93008 assets/css/style.css
    74762 assets/css/style.min.css
    58575 assets/css/tranquilpeak.css
    93888 assets/fonts/FontAwesome.otf
    60767 assets/fonts/fontawesome-webfont.eot
   313398 assets/fonts/fontawesome-webfont.svg
   122092 assets/fonts/fontawesome-webfont.ttf
    71508 assets/fonts/fontawesome-webfont.woff
    56780 assets/fonts/fontawesome-webfont.woff2
    31124 assets/fonts/merriweather-bold.ttf
    24668 assets/fonts/merriweather-boldItalic.ttf
    31304 assets/fonts/merriweather-light.ttf
    22264 assets/fonts/merriweather-lightItalic.ttf
    30972 assets/fonts/merriweather.ttf
    24476 assets/fonts/open-sans-bold.ttf
    24292 assets/fonts/open-sans.ttf
   143844 assets/images/avatar.gif
       43 assets/images/blank.gif
   259098 assets/images/cover.jpg
     6567 assets/images/fancybox_loading.gif
    13984 assets/images/fancybox_loading@2x.gif
     1003 assets/images/fancybox_overlay.png
     1362 assets/images/fancybox_sprite.png
     6553 assets/images/fancybox_sprite@2x.png
	...
	...


# 检查
rclone check ./public azure-chen:\$web

	2019/05/05 14:49:44 ERROR : ... : File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Article/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Config/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Encoding/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Mac/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Network/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Monitor/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Programming/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Static/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 ERROR : tags/Template/index.html: File not in Local file system at /path/to/local/files/work/my-blog/public
	2019/05/05 14:49:44 NOTICE: Local file system at /path/to/local/files/work/my-blog/public: 10 files missing
	2019/05/05 14:49:44 NOTICE: Azure container $web: 10 differences found
	2019/05/05 14:49:44 NOTICE: Azure container $web: 111 matching files
	2019/05/05 14:49:44 Failed to check: 10 differences found
	# 发现 10 个不同

# 同步 （从本地到远端）
rclone sync ./public azure-chen:\$web

# 再次 check
rclone check ./public/ blog:\$web

	2019/05/05 14:51:17 NOTICE: Azure container $web: 0 differences found
	2019/05/05 14:51:17 NOTICE: Azure container $web: 111 matching files
	# 没有不同到了（远端到已经被删除）


# 编辑一个网页并重新生成网站
hexo gen

# 再次 check
rclone check ./public/ blog:\$web

	2019/05/05 14:55:32 ERROR : atom.xml: Sizes differ
	2019/05/05 14:55:32 ERROR : index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : sitemap.xml: MD5 differ
	2019/05/05 14:55:32 ERROR : Deploy-Hexo-static-website-on-Azure-Blob-storage/index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : archives/index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : all-categories/index.html: MD5 differ
	2019/05/05 14:55:32 ERROR : all-tags/index.html: MD5 differ
	2019/05/05 14:55:32 ERROR : categories/Cloud2End/index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : archives/2019/index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : tags/Hexo/index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : archives/2019/04/index.html: Sizes differ
	2019/05/05 14:55:32 ERROR : tags/Azure/index.html: Sizes differ
	2019/05/05 14:55:33 ERROR : tags/blob/index.html: Sizes differ
	2019/05/05 14:55:33 ERROR : tags/deployment/index.html: Sizes differ
	2019/05/05 14:55:33 ERROR : tags/static/index.html: Sizes differ
	2019/05/05 14:55:33 NOTICE: Azure container $web: 15 differences found
	2019/05/05 14:55:33 NOTICE: Azure container $web: 96 matching files
	2019/05/05 14:55:33 Failed to check: 15 differences found
	# 发现15处不同

# 部署（同步）
rclone sync ./public azure-chen:\$web

```

这样，就可以把远端有，而本地没有到删除，而本地新增到也会复制到远端，减少了很多IO。

另外，还有两个GUI工具(for macOS)：

* Rclone OSX - https://github.com/rsyncOSX/rcloneosx
* Rclone Browser - https://github.com/mmozeiko/RcloneBrowser
  
Rclone Browser 略微有点小问题， 并至今有2年没更新了，需要自己查issues[解决](https://github.com/mmozeiko/RcloneBrowser/issues/136)。

--- END ---