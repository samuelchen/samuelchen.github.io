title: Machine Learning Memo 1
date: 2017-12-12 15:19:20
tags: 
  - ML
  - supervised
  - unsupervised
  - classfication
  - regression
  - feature
  - course
  - memo
id: 212
categories:
  - Machine Learning
---

最近开始看Andrew Ng 的 [Machine Learning 系列课程](https://www.coursera.org/learn/machine-learning)，记录一下体会。

### Machine Learning 学习笔记 - 第一周

重要关键词：Supervised, Unsupervised, Regression, Classfication, Features


机器学习主要分为有监管的(supervised)和无监管(两类). 
有监管的基本上分为回归的(regression)和聚类(classfication)两种。
无监管的主要是用来分类。

假如有一件事情来了，如何来区分它适用哪一种方式？我总结了一点。

- Supervised (由人来*监管或者指导*已知答案的对错，从而判度未知答案或者预测）
  - Regression. 根据已有的历史数据来*预测(predict)*将来某个点的数据。例如，天气预测，股票预测。
  - Classfication. 根据已有的历史数据来判断将来具有某些*特征*的某个数据，*是否(weather or not)* 某种状态。例如，某个年龄、某种肿瘤大小的患者是否(yes/no)是恶性的。再如，垃圾邮件标注及判断。
- Unsupervised
  - 从给定的历史数据来*判断哪些数据是聚集在一起(在坐标轴上)*，将这一部分数据归为一类，从而将所有数据归纳为几个分类(在之前，人并不知道结果）。例如，文章的分类。


Feature 是指特征，表现为坐标轴，例如 判断肿瘤一例中的年龄和肿瘤大小就是两个特征。特征数量足够以及合适（并不是多）才能更准确的学习。


-- END

