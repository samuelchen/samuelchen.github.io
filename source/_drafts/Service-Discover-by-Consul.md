---
title: Service Discover by Consul
slug: service-discover-by-consul
comments: True
categories:
	- Architecture & System
tags:
	- Consul
	- HashiCorp
	- microservice
	- service discovery
	- cloud
date: 2018-02-07 15:23:16
updated:
id: service-discover-by-consul
---

> Check [Service Discovery for Propel](https://quip.com/lZy2AXVRzd30) for Implementation for Propel

## Steps to go:

* Solution
    * ~~Investigate and compare different solutions such as ZooKeeper, Etcd, Consul and Eureka.~~
    * ~~Setup Consul cluster with 3 nodes~~
    * ~~Consul start/stop script. Investigate suitable configuration options.~~ 
    * ~~Dynamically register service by API~~
    * ~~Persistently register service by config file~~
    * ~~Service level health check~~
    * Service configurations generation and replica (template)
    * SSL/TLS connection for security
    * ACL for securty
    * Monitor, alert and failover.
* Implementation
    * *Architecture for current Propel cluster.*
    * ***Integration with current Propel services***
        * *Investigate services dependencies*
    * *How current service register automatically*
    * ***How current service/client query services***
    * *Deployment plan*
    * *Test on FT1*



## Software Candidates:

* etcd
    * HA, Distributed, strongly consistent, Key-Value, (Kubernetes, CloudFoundry) Good documents
    * Only configuration, no service discovery integrated. 
    * Work with “Registrator” and “Confd”.
* ZooKeeper
    * High performance. Hadoop. Stable. History
    *  Heavy (too many Java Dependencies). History
    * Need to implement service discovery yourself.
* Consul
    * Lightweight strongly consistent, hierarchical key/value store.  **Implements service discovery system embedded** . out of the box native support for multiple data centers.
* Eureka
    * Spring-Cloud integrated.

## Resources

|	|	|	|	|	|
|---	|---	|---	|---	|---	|
|API Gateway for Microservices	|https://atcswa-cr-atlassian.ecs-core.ssn.hp.com/confluence/display/APIG/API+Gateway+for+Microservices	|	|	|	|
|Service Discovery: Zookeeper vs etcd vs Consul	|https://technologyconversations.com/2015/09/08/service-discovery-zookeeper-vs-etcd-vs-consul/	|http://dockone.io/article/667	|	|	|
|	|	|	|	|	|
|	|	|	|	|	|
|	|	|	|	|	|



|[ec4t02497.itcs.entsvcs.net](http://ec4t02497.itcs.entsvcs.net/)	|15.140.140.81	|consul1	|Service Discovery (Samuel)	|
|---	|---	|---	|---	|
|[ec4t02495.itcs.entsvcs.net](http://ec4t02495.itcs.entsvcs.net/)	|15.140.140.82	|consul2	|Service Discovery (Samuel)	|
|[ec4t02410.itcs.entsvcs.net](http://ec4t02410.itcs.entsvcs.net/)	|15.140.140.34	|consul3	|Service Discovery (Samuel)	|



## Consul Installation & Configuration

Download : https://www.consul.io/downloads.html

* linux 64bit: https://releases.hashicorp.com/consul/1.0.3/consul_1.0.3_linux_amd64.zip?_ga=2.108075650.1013786191.1517545208-1892448366.1517366327


Start a Node

```
consul agent -server -bootstrap-expect 2 -data-dir /opt/consul \
-bind=`hostname -I|awk '{print $1}'` ~~-client=0.0.0.0~~ -config-dir='./conf/' \
-datacenter=dc1 -node=n2
```

Join a cluster (on nodes)

```
consul join 15.140.140.81 15.140.140.82 15.140.140.34
```

OR use —config-file arguments to specify a config file (must end with .json)

> use `“disable_host_node_id”,` or set a “node_id” or leave if automatically created.

```
{
  "datacenter": "atc",
  "data_dir": "./consul_data",
  "log_level": "INFO",
  "node_name": "consul1",
  "server": true,
  "bootstrap_expect": 3,
  "rejoin_after_leave": true,
  "disable_host_node_id": true,
  "retry_join": ["consul2", "consul3"],
  "ui": true,
  "bind_addr": "15.140.140.81",
  "addresses": {
    "http": "0.0.0.0"
  },
  "ports": {
  }
  ,
  "services": [
    `{
        "name": "tomcat", "port": 8080,
`        "check": {
          "id": "tomcat",
          "script": "curl -s http://`ec4t01624.itcs.entsvcs.net:8080 2>1 1>/dev/nil`",
          "interval": "10s",
          "timeout": "3s",
          "status": "passing"
        }``
    }
  ]
}
```

Start

```
$ consul agent -config-file=consul.json
```

Stop

```
$ PID=`ps -ef|grep consul|grep -v grep|awk '{print $2}'`
$ kill -INT $PID
```



### System Service (systemd, initd)

> TODO

### SSL

> TODO

### ACL

> TODO



### register service

> HTTP Port: 8600

> DNS Port: 8500

> Use `“ports”` argument/option to specify port

```
`curl -X PUT -d '{"Datacenter": "dc1", "Node": "n3",
   "Address": "www.google.com",
   "Service": {"Service": "search", "Port": 80}}' \
   http://consul3:8500/v1/catalog/register`
```




### Query Service

```
`dig @consul3 -p 8600 search.service.consul SRV`
```

```
curl [http://consul1:8500/v1/catalog/services](http://consul3:8500/v1/catalog/services)
```



### Health Check

* add `“check”` or `“checks”` to service
    * ``"check": {
          "id": "jekins",
          "name": "Jekins HTTP check",
          "http": "http://`ec4t01624.itcs.entsvcs.net:8080`",
          "method": "GET",
          "interval": "10s",
          "timeout": "1s"
         }``

* To prevent the service failure then removed, add `“status”` to check section
    * "check": {
          ...
          "status": "passing",
          ...
        }

* Register node “check”

> TODO

### Script to register service with check

> Adding service & check by API is still not working (service will be not health and removed)

```
`curl -X PUT -d '{"Datacenter": "atc", "Node": "consul1",
 "Address": "ec4t01624.itcs.entsvcs.net",
 "service": [{
   "service": "jekins", "port": 8080,
`   "check": {
     "http": "http://ec4t01624.itcs.entsvcs.net:8080/jenkins/",
     "interval": "10s",
     "timeout": "3s",
     "status": "passing"
   }
 }]
 }' \`
 http://consul1:8500/v1/catalog/register`
```

check

```
curl http://consul1:8500/v1/catalog/service/tomcat | python -m json.tool
```

### Configuration in file:

Add `“-config-dir”` to start script.

```
$ consul agent -config-file=consul.json -config-dir=./consul.d
```

Add a service (says tomcat) to `./consul.d/tomcat.json` by using `“services”` key (multiple services config)

```
"services": [
    `{
        "name": "tomcat", "port": 8080,
`        "check": {
          "id": "tomcat",
          "script": "curl -s http://`ec4t01624.itcs.entsvcs.net:8080 2>1 1>/dev/nil`",
          "interval": "10s",
          "timeout": "3s",
          "status": "passing"
        }``
    }
]
```

Add a service (says tomcat) to `./consul.d/jekins.json` by using `“service”` key (single service config)

```
{
  "service": {
     "name": "jenkins", "port": 8080,
     "check": {
       "http": "http://ec4t01624.itcs.entsvcs.net:8080/jenkins/",
       "interval": "10s",
       "timeout": "1s"
     }
  }
}
```

Restart consul.

### Configuration Template/Replica




--- END ---
