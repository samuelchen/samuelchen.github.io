---
title: 为 Hexo, Hugo 和 VSCode 添加 markdown 流程图(mermaid)支持
slug: add-markdown-chart-to-vscode-hexo-and-hugo
date: 2020-02-06 15:54:51
updated:
categories:
	- Utility
tags:
	- blog
	- diagram
	- flowchart
	- mermaid
	- markdown
	- hexo
	- hugo
	- vscode
---

最近在写blog时想画流程图，但又因为可能会频繁修改而不想用图片。因此经过一番搜寻，发现了 [`mermaid`](https://mermaid-js.github.io/mermaid/) 
这个工具，支持用 `markdown` 撰写 **流程图**，**时序图**，**甘特图**，**类图** 等各种（简直神器）。
最让人高兴的是，Hexo（博客）, Hugo（网站） 以及 VSCode 都有插件或者方法可以支持。

以下就分别介绍如何在VSCode, Hexo 以及 Hugo 中安装设置来支持 `mermaid`.

## VSCode

在 VSCode 中安装插件 [`Markdown Preview Mermaid Support`](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)，
就可以在编辑时实时预览 `markdown` 中的 `mermaid` 图形了，图形编写使用 \`\`\` 包围，并以 `mermaid`作为语言标签。

例如（：

```markdown
	` ` `mermaid
	graph TD;
		A-->B;
		A-->C;
		B-->D;
		C-->D;
	` ` `
```

如图所示：
![](vscode-markdown-flowchart.png)


## Hexo

Hexo 默认是不支持 `mermaid` 的，需要添加插件支持，在你的 Hexo Blog 目录下，输入命令：

```sh
npm install --save hexo-filter-mermaid-diagrams
```

此外，如果使用的主题支持`mermaid`，需要在所用主题的 `_config.yml` 中开启 `mermaid` 支持：

```yml
# Mermaid (markdwon to flow chart, seq chart, class chart ...)
mermaid:
  enable: true
  # Available themes: default | dark | forest | neutral
  theme: default
```

	*请稍等一段时间，以下代码会变为SVG流程图*

```mermaid 
graph TD;
	A-->B;
	A-->C;
	B-->D;
	C-->D;
```

**如果所使用的主题不支持 `mermaid`，请参考 []()**

### 给 Hexo 主题添加 `memaid` 支持

最简单的办法，利用`mermaid`官方CDN，直接在 ${blog}\themes\tranquilpeak\layout\_partial\script.ejs 
中修改，文件最后增加两行如下

```javascript
<script src="https://unpkg.com/mermaid@8.4.6/dist/mermaid.min.js"></script>
<script>mermaid.initialize({startOnLoad:true});</script>

```

如果希望这个主题能支持更多配置，可以在主题的 `_config.yml` 中增加 `mermaid` 配置：

```yaml
# Mermaid (markdwon to flow chart, seq chart, class chart ...)
mermaid:
  enable: true
  # Available themes: default | dark | forest | neutral
  theme: default
  # You can add more options
```

然后在 `${blog}\themes\tranquilpeak\layout\_partial\script.ejs` 中修改，文件最后增加：

```javascript
<% if (theme.mermaid.enable) { %>
    <%- js('assets/js/mermaid.min.js') %>
    <script>
        $(document).ready(function() {
            var mermaid_config = {
                startOnLoad: true,
                theme: '<%- theme.mermaid.theme %>',
                flowchart:{
                    useMaxWidth: false,
                    htmlLabels: true
                }                
            }
            mermaid.initialize(mermaid_config);
        });
    </script>
<% } %>
```

其中 `theme.mermaid.enable` `theme.mermaid.theme` 就是你增加的主题配置选项，具体
详见 `mermaid` 官方文档。

最后，可以将 `mermaid.min.js` 放到主题的js目录 `${blog}\themes\tranquilpeak\source\assets\js\` 下，
再使用如下技巧，当 CDN 出问题时，可以使用本地文件。

```javascript
    <!-- if CDN fails, use local file -->
    <script src="https://unpkg.com/mermaid@8.4.6/dist/mermaid.min.js"></script>
    <script> window.mermaid || document.write('<script src="/assets/js/mermaid.min.js"><\/script>')</script>
```

## Hugo

	to be written
	理论上和 Hexo 类似，待写


--- END ---