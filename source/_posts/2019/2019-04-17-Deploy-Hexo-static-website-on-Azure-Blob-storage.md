---
title: 在 Azure Blob 存储上部署 Hexo 静态网站
slug: deploy-hexo-static-website-on-azure-blob-storage
categories: Architecture & System
tags:
  - Azure
  - Hexo
  - blob
  - static
  - deployment
  - cloud
comments: true
date: 2019-04-17 00:10:39
updated:
id: deploy-hexo-static-website-on-azure-blob-storage
---

    _所有静态网站都可用采用此方法_

之前，[个人博客](http://blog.samuelchen.net)一直都是用 `Hexo` 生成并部署为 `GitHub Pages`。
最近知道，因为百度的爬虫太频繁而被 GitHub 屏蔽了，所以所有部署在 GitHub 上的网站都没有收录。
不深究这个理由是否靠谱，得给博客换个地方了。

手头有 Azure 和 Vultr 的 VPS，但考虑到部署静态网站到 VPS 有点大材小用，而且需要部署 HTTP 
Server 防火墙，FTP/Rsync/SSH 等等挺麻烦，就寻思着是不是能用对象存储来做。于是翻看了 Azure
Blob 到文档，发现真还行，而且还挺简单，内置支持。

首先新建**全局唯一**的存储账号，比如我选则了 `chen`，这个会作为你 Azure 存储的一个 End 
Point，比如 chen.blob.core.windows.net，可以直接通过这个域名来访问你的存储对象。这个时候
要注意一点，一定要选择 `StorageV2 (通用版 v2)` 类型，只有这个类型才支持直接部署静态网站。
我之前就是选择了 `v1` 类型，导致无法自动识别 `index.html` 而无法访问。建好后，选择 
`静态网站` 菜单并 **启用**，系统会自动生成名为 `$web` 的 `容器(Container)`，作为存储网站的根目录。

以上配置完成后，就用 `hexo generate` 命令生成你的网站，网站生成后都在 `public` 目录
下，这些不细说。然后需要做的是把生成的网站传到刚建立到容器 `blog` 中，有几种方法可以做到：

1. 直接使用浏览器在 Azure 门户页面 `存储资源管理器` 中上传
2. 下载 `存储资源管理器` 桌面版，上传
3. 使用 `AzCopy` 上传 （需要.net）
4. 使用 Azure Client 命令行工具 `az`

前面2种方法都很简单，找到相应位置或者下载软件就行了，第3个需要.net，不足够通用，我使用到是第4种
方法，简单写了个脚本，每次自动上传，主要是下面这句，其他都省略了:

```sh
#!/usr/bin/env sh

BLOB_ACCOUNT="chen"     # blob 账号
BLOB_CONTAINER='$web'   # blob 容器

hexo clean && hexo generate && az storage blob upload-batch -d $BLOB_CONTAINER --account-name $BLOB_ACCOUNT -s ./public

```
然后就可以用 `https://chen.z?.web.core.windows.net` (？是某个数字，z? 代表一个地区) 
访问你的网站了。

安装 Azure Client 的步骤就不写了，直接看文档。安装好后，记得运行 `az login` 登录。

最后，如果你有自己的域名，可以选择 `自定义域` 来配置，同时要配置 DNS.

这种方法非常简单，费用也很低，基础 1G 才大概几美分。不过有一点不好的是，`v2` 类型的 blob 存储
还有存取访问计费，每万次也有几～几十美分，而 Hexo 生成的静态网站文件很多，一次上传就得几百上千
个文件，而且只要改配置或者模版，文件就都大多数都修改了，得全部上传。

Azure Blob 部署的静态网站，如果用 `windows.net` 访问，是自带 `https` 的，如果你需要给
自定义域名也用上https，需要配置 `CDN`。而且，`CDN` 会自动选择不同的地区访问，blob 是固定
地区的（比如 blob 账号、容器是在 美国东部 US-EAST，那么亚洲访问就稍慢）。

--- END ---
