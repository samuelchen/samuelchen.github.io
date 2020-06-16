---
title: Encrypt/Decrypt and store sensitive content with HashiCorp Vault
slug: encrypt-decrypt-and-store-sensitive-content-with-hashicorp-vault
categories:
  - Cloud2End
tags:
  - vault
  - HashiCorp
  - encryption
  - decryption
  - Alibaba Cloud
  - cloud
  - microservice
comments: true
date: 2019-02-27 12:12:39
updated: 2020-06-16
id: encrypt-decrypt-and-store-sensitive-content-with-hashicorp-vault
---



We are encrypting sensitive content with AES algorithm and storing them in DB. Now we plan to leverage HashiCorp to do this.

So far we have 2 kinds of data need to be encrypted: one is the Alicloud key and secret of customers, the other is the marked sensitive variable or parameters such as VM password. Vault provides several secrets engines to achieve these.

Vault has a secret engine named  AliCloud. But it can only manage one account with configuring a pair of its key and secret in a single path. It can only manage the policies of this account. Which means if we want store multiple customer AliCloud accounts, we need to define multiple paths in Vault for each account and configure key/secret pairs for each account manually. It's no sense. So it's not useful for us.

Above all, we could only use the `Key/Value` secrets engine. 

### Configuration

We define some configurations for using Vault.

* `ENCRYPTION_METHOD`  -  to identify which method will be used. `VAULT `for HashiCorp vault. `AES `for encryption with AES algorithm and store in DB.  `ENCRYPTION_METHOD  = “VAULT” | “AES”`

* `VAULT_KV_PATH` - Vault path is related to secrets engine. This need to defined from architecture level so that all components which uses Vault will follow it. And avoid namespace conflict. By default, the base path for `Key/Value` engine is `“kv”`. e.g. `VAULT_KV_PATH = “kv/cpsapi”`

### NOTABLE IMPLEMENTATION details

* To distinguish encryption methods for the encrypted data, we add prefix for it. e.g.  for AES, it will be `“**$:AES:$**qowzobv1GoC8tB7dOrHJpA==PXyKO2kLX6C4oD8a+e5BlMQwD2q8vvu3poI5rishmVM=”` . If data encrypted by Vault, the encrypted data will not be stored in DB. So that it will only remains `“$:VAULT:$”` 
* Two utility methods wrapper `encrypt/decrypt` were created. In them, we automatically check which methods will be used and apply it. If the `ENCRYPTION_METHODS` was changed after the system runs for some while, we may be facing some data was encrypted by AES but now the decryption method is VAULT. For this scenario, we have 2 choices:
    * Decrypt the data as it was. Encrypt it as configured.
    * Raise an exception to notify. This means if a encryption methods is used when the system initializing, it can not be changed.
* Data length changed. Encrypted data will has a different length compares to origin data. So the DB field length need to be changed. If the ENCRYPTION_METHODS changed, we have 2 choices:
    * Change the field max length to max of all encrypted data length. e.g. Origin field length is 10. AES encrypted data length is 64. VAULT encrypted data length is 9. The we choose max(64, 9) = 64.
    * Use the encrypted data length as configured methods and Raise an exception to notify. “ENCRYPTION_METHODS can not be changed.”
* Another problem for data length changing is, in admin panel, the data length validation is not valid anymore. So far no good way to resolve (No place to store the origin length in DB) If we only allow VAULT, this and above 2 issue may not existed. (we keep the filed with fixed length. we do not add prefix.)
* Each access to sensitive data will cause an REST API call to Vault server. This could be potential performance issue.


