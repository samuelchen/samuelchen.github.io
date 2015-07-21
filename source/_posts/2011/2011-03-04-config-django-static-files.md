title: Django 静态文件配置
tags:
  - Config
  - Django
  - Programming
  - Python
  - Static
id: 120
categories:
  - Programming
date: 2011-03-04 15:59:00
---

Django 自带的admin 用户及权限管理是一个很不错的功能，但在开发的时候，如果仅仅只是按照教程中介绍的去掉 urls.py 中相应的注释，那么你很有可能看到的是一个光秃秃的裸体页面，换句话说，就是页面的样式都失效了。

这是怎么回事？其原因就是 Django 不处理静态文件，其静态文件管理需要通过配置，让服务器直接访问。同时，在开发环境中，如果你是用manage.py runserver 的方式运行调试，更是麻烦。在网上找了很久，始终也没有一个很全面的解决方案。

自动动手，丰衣足食，参考 Django 官网的介绍，终于解决了。废话不多说，解决方案如下：

开发环境（manage.py)

参考 [http://docs.djangoproject.com/en/dev/howto/static-files/#serving-static-files-in-development](http://docs.djangoproject.com/en/dev/howto/static-files/#serving-static-files-in-development).
网上有很多介绍改这个 MEDIA_ROOT, MEDIA_URL 改那个 STATIC_ROOT, STATIC_URL 的，注意，完全没有必要，开发时，这些都不需要改就可以运行。
MEDIA 是指你上传的文件存放，比如图像，视频，压缩包之类的，而STATIC是你网站运行需要依赖的一些静态文件，比如css, js, template 等等。开发时先不管它们。

*   首先，复制 C:/Python27/Lib/site-packages/django/contrib/admin/media/ 下的文件，到你网站的 c:/mysite/static/ 下，那么就有了 c:/mysite/static/media/ 目录。
*   其次，将 /static/media/ 改为 /static/admin/ 。 这个修改是为了符合 ADMIN_MEDIA_PREFIX='/static/admin/'，你网站上的admin的静态文件都会渲染成 http://server/{{ADMIN_MEDIA_PREFIX}}/xxx/xxx.css 之类，也就成了 http://server/static/admin/xxx/xxx.css ，这样就能找到正确的服务器静态文件了。同时，也是为了避免 media 和 static 造成混淆了，前面说了，MEDIA 实际上是用来存放上传下载文件的。
*   然后，打开你网站的 c:/mysite/settings.py ，修改 STATICFILES_DIRS 段
<pre>STATICFILES_DIRS = (    'c:/mysite/static/',)</pre>

*   最好，修改 c:/mysite/urls.py，在 urlpatterns 下面增加一行
<pre>urlpatterns += staticfiles_urlpatterns()</pre>
别忘了头上加上一句
<pre>from django.contrib.staticfiles.urls import staticfiles_urlpatterns</pre>
运行python manage.py runserver，用浏览器访问 http://localhost:8000/admin/ ， 看看是不是好了。

部署环境

以后试过了再写。

&nbsp;