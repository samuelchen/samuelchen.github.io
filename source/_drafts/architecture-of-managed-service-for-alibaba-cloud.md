---
title: Architecture for distributed Python/Django/Worker applications.
slug: architecture-for-distributed-python-django-worker-applications.
comments: true
categories: Architecture & System
tags:
	- cloud
	- architecture
	- Python
	- Django
	- worker
	- PostgreSQL
	- Alibaba Cloud
id: architecture-for-distributed-python-django-worker-applications.
---

This is the architecture I designed for service **Managed Service for Alibaba Cloud" of company production.
It's also the common architecture that can be used to deploy Python applications with workers. This is a easy to upgrade architecture. It can simple add other service such as API Gateway. Or becomes into microservices.
I removed some sensitive information such as source code, configuration and so on.

## Requirements

* OS - Linux (CentOS 7 or 6, Ubuntu ..)
* Python 3.6 (< 3.7) with pip, virtualenv ...
* gunicorn
* nginx
* supervisor (if need)
* DB - Postgresql (or MySQL)
* Task Queue - Redis (or RabbitMQ)
* source code - Removed

## Install

	Removed

## Setup API

	Removed

## Architect

Note: 

* *Nginx can be extracted on top of all boxes.* 
* Stack Files can be stored in individual box or OSS.
* For now, Celery Worker must be in API Box (for HA, should no related to API. such as create/access)

```

                                  Client APP
                                       |
   ----------------------------- LB / Firewall --------------------------------
                                       |
                                      /|\
              _________cross_________/ | \_________zone___________
             |                         |                          |
         API Box 1/M              API Worker Box 1/N           APP Box 2/M        
   ----------------------     ----------------------    ---------------------- 
  |        Nginx         |   |        Celery        |  |        Nginx         |
  |          |           |   |          |           |  |          |           |
  |         / \          |   |       N Workers      |  |         / \          |
  |  Static   Gunicorn   |   |  _________|________  |  |  Static   Gunicorn   |
  |  Files       |       |   |  |     |     |    |  |  |  Files       |       |
  |          N Workers   |   | ...   ...    |   ... |  |          N Workers   |
  |              |       |   |             Task     |  |              |       |
  |  ____________|_____  |   |                      |  |  ____________|_____  |
  |  |     |     |    |  |   |                      |  |  |     |     |    |  |
  | ...   ...    |   ... |   |                      |  | ...   ...    |   ... |
  |           Django     |   |                      |  |           Django     |
  |            WSGI      |   |                      |  |            WSGI      |
   ----------------------     ----------------------    ---------------------- 
             |                           |                         |
             -------------------------------------------------------
                        |                                |
                 DB Box/Cluster                  Queue Box/cluster   
               ----------------------          ---------------------- 
              |     Postgresql       |        |        Redis         |
              |                      |        |                      |
               ----------------------          ---------------------- 

```


-- END --