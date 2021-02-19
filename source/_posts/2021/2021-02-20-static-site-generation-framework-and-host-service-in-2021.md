---
title: 2021年静态站生成与部署相关的服务和框架
slug: static-site-generation-framework-and-host-service-in-2021
date: 2021-02-20 00:37:37
updated:
categories:
	- Utility
tags:
	- Hugo
	- Hexo
	- Next.js
	- Gatsby
	- Forestry 
	- Headless
	- CMS
	- react.js
	- static
---

之前一直用Hugo 和 Hexo 来生成个人网站和博客，今天无意发现了一些新的服务和框架可
以用来部署或者生成静态网站，加上react 和一些serverless服务，几乎可以完整的建立
动态站。 这里记录一下。

* [Next.js](https://nextjs.org/) - "生产级别的 React 的框架"
	支持很多开发者方便的特性

* [Gatsby](https://www.gatsbyjs.com/) - "一个前端搞定一切"
	号称非常快，可用于创建**完整站点**。

* [Forestry](https://forestry.io/) - 无头CMS
	直接在Git仓库上编辑，可以触发工作流编译部署

* [Netlify](https://www.netlify.com/) -  "基于Git的工作流, 函数计算平台"
	直接从Git仓库创建站点/服务，push触发工作流编译部署，函数计算服务

