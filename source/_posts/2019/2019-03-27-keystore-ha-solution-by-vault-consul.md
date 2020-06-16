---
title: 基于 HashiCorp Vault 和 Consul 的密钥仓库解决方案
categories:
  - Architecture & System
tags:
  - cloud
  - HashiCorp
  - Vault
  - Consul
  - keystore
  - cluster
  - deployment
id: keystore-ha-solution-by-vault-consul
comments: true
date: 2019-03-27 04:49:12
updated: 2020-06-16 23:14:03
---

Keystore cluster based on Vault & Consul

具体部署可参考 [敏感信息的加密存储](../encrypt-decrypt-and-store-sensitive-content-with-hashicorp-vault) 以及 [基于 Consul 的服务发现](../service-discover-by-donsul)

<!--more-->

Vault + consul 配置

Consul 配置. consul1.json: :

```
{
  "datacenter": "cn-shanghai-b",
  "data_dir": "./consul",
  "log_level": "INFO",
  "node_name": "consul1",
  "server": true,
  "bootstrap_expect": 3,
  "rejoin_after_leave": true,
  "disable_host_node_id": true,
  "retry_join": ["vault2", "vault3"],
  "ui": true,
  "bind_addr": "172.16.2.240",
  "addresses": {
    "http": "0.0.0.0"
  },
  "ports": {
  }
  ,
  "services": [
    {
        "name": "vault",
        "port": 8200,
        "check": {
          "id": "vault1",
          "http": "http://vault1:8200",
          "tls_skip_verify": true,
          "interval": "10s",
          "timeout": "3s",
          "status": "passing"
        }
    }
  ]
}
```

Vault 配置. vault.hcl:

```
storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

disable_mlock = 1
api_addr = "http://vault:8200"
ui = true
```

--- END ---
