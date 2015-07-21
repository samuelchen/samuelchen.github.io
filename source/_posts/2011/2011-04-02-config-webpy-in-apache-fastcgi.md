title: web.py 在 apache + fastcgi 配置 tips
tags:
  - Config
  - Linux
  - Programming
  - Python
  - Ubuntu
  - web.py
id: 122
categories:
  - Programming
date: 2011-04-02 21:56:00
---

根据web.py官网的说明，配置使其运行在apache + fastcgi 上，碰到了许多问题，耗了两天时间才整明白。一方面是apache的配置不熟悉，另外一方面是其官方文档也有些疏漏，问题及解决办法如下(ubuntu 10.04)：

*   调试日志
web.py 应用挂在服务器上以后，stdout/stderr，都好像转了（查网上的，未验证），另外apache的用户是www-data，用户当前目录也是没有权限，所以logging要记录在/tmp下，或者单独建一个/log目录给写权限才行，这个一般规划好了没什么问题。
另外，也可以做个ApacheLogHandler来将日志记到apache的日志文件中，这个网上可以搜到。
然后就是，apache的日志文件在/var/log/apache2/ 。如果你的网站配置文件修改了日志位置，要注意这个地方只记录了一部分，还有一些仍然会记录在default位置。
最后，可以使用traceback包来记录未处理的异常，代码如下：
<pre>
try:
    # web.py code
    # urls = ...
    # ...
    # app.run()

except Exception, e:
    f = None
    if os.name == 'posix':
        f = open('/tmp/yule_unhandled_error.log', 'w')
    else:
        f = open('%s/yule_unhandled_error.log' % os.environ['temp'], 'w')
    traceback.print_exc( file=f )
    traceback.print_exc( file=f )
    f.close()
</pre>

*   python 库路径 (PYTHONPATH)
在 apache + fastcgi 中运行 python cgi，如果你使用了 PYTHONPATH 来引用库，你会发行看到的永远是 500 Internal Error。这是因为apache没有复制shell中的环境变量。
注意，不要使用envvar文件，或者在网站配置文件中用setEnv，passEnv 等方法，这些方法我试过完全没有用。
你要做的是，用代码将所有的路径全部都加到sys.path中。代码如下：
<pre>
    import os, sys
    python_path = "/you/python/lib/path:/you/python/lib/path2".split(':')
    for path in python_path:
        sys.path.insert(0, path)
</pre>
当然你可以检查path是否已经加入了，注意路径访问权限，牢记现在的用户是www-data。
*   静态文件
好了，现在都配好了，再访问网站 ... OK 出来了！
等等！ 怎么搞的，样式表，图像怎么都显示不出来了？
原来是web.py [官网的配置文件](http://webpy.org/cookbook/fastcgi-apache)有少许疏漏，静态文件的转发不对！
假设静态目录是网站根下的 /static/ （这也是web.py的推荐位置），那么我们要做的是修改网站配置文件的mod_rewrite 规则为:
<pre>
    # 修改 ifmodule 这一节，注意蓝色行
       RewriteEngine on
       RewriteBase /
       RewriteCond %{REQUEST_URI} !^/icons
       RewriteCond %{REQUEST_URI} !^/favicon.ico$
       <span style="color: blue;">RewriteCond %{REQUEST_URI} !^/static/  ### 注意这一行 </span>
       RewriteCond %{REQUEST_URI} !^(/.*)+code.py/
       RewriteRule ^(.*)$ code.py/$1 [PT]
</pre>
好了，现在再试试，是不是已经好了 :)