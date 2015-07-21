title: Django 如何在模板(template)中使用settings中预定义的变量
tags:
  - Django
  - Python
  - Static
  - Template
  - Programming
id: 121
categories:
  - Programming
date: 2011-03-05 00:26:00
---

在Django中编写模板(template)的时候， 有时候可能会用到settings中设定的变量， 比如说STATIC_URL。 此时， 如果你直接使用 `{{ STATIC_URL }}` 是取不到值的。 那么怎么才能在模板中使用呢？ 难道非得在每个view中添加到context中吗？

答案是否定的。 根据Django文档中所描述， 我们至少有两种方法可以直接使用。 http://docs.djangoproject.com/en/dev/howto/static-files/#referring-to-static-files-in-templates

<!--more-->

方法1：

使用 `{ % load static %}` 载入 static 模块，然后使用 `{ % get_static_prefix %}` 就可以了。
<pre>{ % load static %}

&lt;img src="{ % get_static_prefix %}images/hi.jpg" /&gt;</pre>
当然也可以将其定义为变量以多次使用
<pre>{ % load static %}
{ % get_static_prefix as STATIC_PREFIX %}
&lt;img src="{{ STATIC_PREFIX }}images/hi.jpg" /&gt;
&lt;img src="{{ STATIC_PREFIX }}images/hi2.jpg" /&gt;</pre>
方法2：

这个方法是推荐的方法， 直接使用 RequestContext 来传递。 其原因就是因为settings中定义的变量都会在request中传递， 但是response的时候是没有这些context的， 所以Django专门定义了RequestContext来帮你组合 （其实你自己也可以做这件事）。
<pre>#注意这里是django.template，由此可见是专门为template设计的
from django.template import RequestContext

def some_view(request):
    # ...    
    return render_to_response('my_template.html',
                              my_data_dictionary,
                              context_instance=RequestContext(request))</pre>
这个实际作用就是将request中的context全部都加到response的context中去。

这样，你就可以直接在模板中使用`{{ STATIC_URL }}` 来使用了，当然其他的变量也是可以的，不需要每个都单独去load了。
<div></div>