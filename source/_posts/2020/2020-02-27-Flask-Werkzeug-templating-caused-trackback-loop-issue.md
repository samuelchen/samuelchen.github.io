---
title: Flask (Werkzeug) templating caused trackback loop issue
draft: draft
date: 2020-02-27 15:59:17
updated:
categories: Programming
tags:
	- Flask
	- Python
	- Jinja
	- Werkzeug
	- bug
	- trackback
	- template
---

Today, I was facing an issue when using `Flask` template.

If use an dash "-" linked variable name in Flask template, it will cause Flask to hang without 
throwing any exception.

At beginning, I guess it may be an issue of `Jinja` template rending. But after traced in IDE 
(Pycharm community 2019.3), I saw that templating raised the exception and `Werkzeug` is handling. 

At first I uses Flask debug mode and IDE **debug** run to step into codes to dig it. IDE gets
slower and slower and the debugger hung in `Werkzerg` codes.

Eventually, I found an endless loop in `Python\Lib\traceback.py` to walk trackback stacks. The 
trackbacks are stored in a link which nodes point to next. In `flask\templating.py`, 
`flask\app.py` and `werkzeug\debug\tbtools.py`, the exception was catched. In 
`handle_exception()` of `flask\app.py`, `Werkzeug` wants to log it and print it out. 
The trackback link has looped reference as below picture.

![](flask_tb_next_loop_ref.png)

Simple code to re-produce it as below (**"font-size"** variable caused.).

```python
import sys
from flask import Flask, request, render_template_string, make_response, url_for, redirect


app = Flask(__name__)

template_page = '''
<html>
<head>
<meta charset="{{ encoding }}" />
<meta http-equiv="content-type" content="text/html; charset={{ encoding }}" />
<style type="text/css">
  body, pre, p, div, input, h1,h2,h3,h4,h5 {
    font-family : Consolas, Courier New;
  }
</style>
</head>
<body>
    <div id="wrapper" style="font-size:{{ font-size }}em">
        {{ content | safe }}
    </div>
</body>'''


@app.route('/', methods=['GET'])
def index():
    context = {
        "encoding": 'utf-8',
        "font-size": 0.9,
        "content": 'hello flask'
    }
    resp = make_response(render_template_string(template_page, **context))
    resp.headers['Content-Type'] = 'text/html; charset=utf-8'
    return resp


if __name__ == "__main__":
    # app.run(debug=True, host='0.0.0.0', port=8080)

    app.run()
```

Raised Github issue at `Flask`:

* https://github.com/pallets/flask/issues/3516

Environment:

* Window 10
* Python 3.6.8150.1013 (venv)
* Flask 1.1.1
* Werkzeug 0.16.1

Possible related Python issue:

* [Issue9427 - logging.error('...', exc_info=True) should display upper frames, too](https://bugs.python.org/issue9427)
* [Issue1553375 - Add traceback.print_full_exception()](https://bugs.python.org/issue1553375)

-- END --