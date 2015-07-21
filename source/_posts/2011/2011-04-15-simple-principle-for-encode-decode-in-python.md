title: 'python 的编码，关于 encode, decode 的简单原则'
tags:
  - Encoding
  - Python
id: 123
categories:
  - Programming
date: 2011-04-15 15:14:00
---

Python 中 encoding 的处理其实已经很简单了，根据我这近一个月来用python的经验，有一个简单的原则可以作为参考。

基于python 2.7
1\. 类型要清楚， unicode 不是 str
2\. decode 之后的结果都是 unicode
3\. encode 之后的结果都是 str，其编码是你encode的参数
4\. 输出一律用 str
5\. 存取一律用 unicode

就这么简单，编码基本上就不会错了。
举个例子，有个GBK编码的文件 name.txt，每行一个人名
<pre>for line in open('name.txt').readlines():
  print line # 这时候 line 都是 gbk 的 
  str x = line.decode('gbk') # 转成 unicode 
          #(建议这么做，原则：但凡输入的，一律转换成unicode后处理)
  print x # 输出 unicode (不建议这么做)
  print x.encode('utf-8') # 输出 str (建议这么做，原则：但凡输出，一定编码成str)
  store_to_db(x) # 这时候存的都是unicode 
  my_str = x.encode('big5') # 转成 big5了 
  print m_str # 输出的是 big5 的 str</pre>
此外，encode 的时候不一定会成功，这时候会raise一个exception，这是因为 encode 还有一个参数用来控制encode失败后的处理，default是strict，也就是抛异常。

你可以用 encode(src, 'replace') 来处理，replace就表示碰到转不了的，用问号'?'来代替，而不是抛异常。

具体用法，查文档。

同样，输出的时候，输出流也需要有编码。比如stdout默认是ascii的，而你要输出unicode，就需要得到一个基于unicode的输出流，output = codecs.getwriter('utf-8')(sys.stdout)