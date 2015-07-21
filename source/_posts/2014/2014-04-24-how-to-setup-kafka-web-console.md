title: How to setup Kafka Web Console
tags:
  - Config
  - MQ
  - Monitor
  - Kafka
id: 211
categories:
  - Cloud2End
date: 2014-04-24 15:15:11
---

This project is hosted at [https://github.com/claudemamo/kafka-web-console](https://github.com/claudemamo/kafka-web-console)

It's a very simple console that only suit for learning Kafka purpose.
<div></div>
<div>

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
[![kafka-web-console2](http://blog.samuelchen.net/wp-content/uploads/2014/04/Image.png)](http://blog.samuelchen.net/wp-content/uploads/2014/04/Image.png)
    *   Check status to see if connected[![kafka-web-console2](http://blog.samuelchen.net/wp-content/uploads/2014/04/Image1-1024x127.png)](http://blog.samuelchen.net/wp-content/uploads/2014/04/Image1.png)

*   "Database xxx needs evolution!" - Solution for database is not initialized.
Done.

</div>