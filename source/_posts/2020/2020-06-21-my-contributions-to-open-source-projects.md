---
title: my contributions to open source projects
categories:
  - Programming
tags:
  - cloud
  - aliyun
  - Python
  - object-c
  - iOS
  - truepy
  - scrapy
  - tornado
  - flask
  - jinja
  - kafka
  - fmdb
  - zookeeper
  - touchxml
  - formalchemy
  - article
draft: draft
comments: true
date: 2020-06-21 21:40:03
updated:
---


_整理了自己对开源软件做的一些修改、提交或者错误报告_


- Alibaba Cloud SDK for Python
  * support proxy environment var
    https://github.com/aliyun/aliyun-openapi-python-sdk/pull/72
  * review for commit DescribeFileSystemStatistics
    https://github.com/aliyun/aliyun-openapi-python-sdk/pull/315
  
- truepy - Python library for generating TrueLicense licenses
  * Fix importing issue by replace "pycrypto" with "pycryptodome"
  https://github.com/moses-palmer/truepy/pull/5

- Scrapy/w3lib - lib for html parsing in scrapy spider framework
  * Report issue "Scrapy can not auto detect GBK html encoding" (work around in scrapy pipline/middleware way myself)
    https://github.com/scrapy/w3lib/issues/155
    
- Flask/Jinja - template engine for python
  * Found & report bug. "Traceback formatting in Python 3.6 32-bit Windows causes hang"
    https://github.com/pallets/jinja/issues/1162
    
- Tonado - Python high performace web framework
  * Fix broken demo 
    https://github.com/tornadoweb/tornado/pull/1792

- KafkaOffsetMonitor - Montior tool for Kafaka
  * Report bug about node on zookeeper cluster and figure out work around.
    https://github.com/quantifind/KafkaOffsetMonitor/issues/14
  
- fmdb - Object-C wrapper for SQLite
  * Fix i myself reported bug (owner used his own fix). listed in contirbutors (line 36).
    https://github.com/ccgus/fmdb/pull/105
    https://github.com/ccgus/fmdb/blob/master/CONTRIBUTORS.txt
    
- TouchXml - iOS port of NSXMLDocument (XML parser)
  * Add build target for framework
    https://github.com/TouchCode/TouchXML/pull/33
    
- Formalchemy - HTML form generation framework by Python
  * fix to ignore the KeyError while sync data to model.
    https://github.com/FormAlchemy/formalchemy/pull/13
  * typo fix
    https://github.com/FormAlchemy/fa.jquery/pull/7
   