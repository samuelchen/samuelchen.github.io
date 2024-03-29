---
title: How to setup Kafka Web Console
slug: how-to-setup-kafka-web-console
tags:
  - configuration
  - MQ
  - monitor
  - Kafka
  - open source
  - deployment
categories:
  - Utility
date: 2014-04-24 15:15:11
updated: 
comments: true
id: how-to-setup-kafka-web-console
---

"Kafka Web Console" is a open source monitor tool for `Kafka`. 

<!--more-->

This project is hosted at [https://github.com/claudemamo/kafka-web-console](https://github.com/claudemamo/kafka-web-console). It's a very simple console that only suit for learning Kafka purpose. (Until when the post written.)


*   Install Play Framework.

    *   Download here [http://www.playframework.com/download](http://www.playframework.com/download)
    *   Unzip to /path/to/play
    *   Build Play. /path/to/play/framework/build

*   Install Kafka-web-console.

    *   git clone [https://github.com/claudemamo/kafka-web-console.git](https://github.com/claudemamo/kafka-web-console.git)  /path/to/kafka-web-console
    *   (or download the stable zip from [https://github.com/claudemamo/kafka-web-console/releases](https://github.com/claudemamo/kafka-web-console/releases))

*   Run the server

    *   Enable port 9000 for the server.
    *   cd /path/to/kafka-web-console
    *   /path/to/play/play start
    *   Then the web console is servicing on port 9000.

*   Configuration

    *   register zookeeper
    ![](img1.png)

    *   Check status to see if connected
    ![](img2.png)


*   "Database xxx needs evolution!" - Solution for database is not initialized.
    *  use “play -DapplyEvolutions.default=true” to start. 
    *  Or add “applyEvolutions.default=true” in conf/application.conf 

--- END ---

