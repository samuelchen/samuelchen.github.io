---
title: Solution selection for sensitive content storing
slug: solution-selection-for-sensitive-content-storing
categories:
  - Cloud2End
tags:
  - Alibaba Cloud
  - keystore
  - vault
  - encryption
  - decryption
  - AES
  - RSA
  - MD5
  - SHA
  - cloud
  - microservice
comments: false
date: 2019-01-11 19:10:38
updated: 2020-06-16
id: solution-selection-for-sensitive-content-storing
---


## Background & Purpose

In Alicloud API project, we have some sensitive data such as secret key, vm password and so on stored in database. To avoid store plain text, we need a solution to encrypt and decrypt sensitive data. 

## Solutions

### Keystore

Systems that provide ability to store sensitive key/token/password. Encryption and decryption will handled by the system.

* IDM

* Valut

Need to involve a new system and maintain it. 

### Encoding

Reversible character encoding algorithms. Same algorithm will be used for encryption and decryption.

* HEX, BASE64 (BASE##), UTF8 and etc.
* compaction algorithm such as Huffman Coding, ZIP (Deflate) , JPEG, MPEG and etc.
* etc

Easy to be decode. 

### Abstract algorithm

Irreversible algorithm. Not appropriate for us.

* MD5
* SHA-1, SHA-256
* MAC
* etc.

### Symmetric encryption

Reversible algorithm. Plaint text (data) is encrypted or decrpyted with given private key (shared secret) with same algorithm. https://en.wikipedia.org/wiki/Symmetric-key_algorithm

* DES
* AES
* RC
* etc.

Need to share the private key.

### Asymmetric encryption

Reversible algorithm. Plaint text (data) is encrypted with public key. The encrypted data is decrypted only with private key. The public key can be openly distributed without compromising security. Encryption and decryption in different way.  https://en.wikipedia.org/wiki/Public-key_cryptography

* RSA
* DSA
* ECC
* etc.

## Anaysis

* Keystore - One more system means one more point need to care the load, failure and so on. Need to communicate between severs even to set/get a property of resource (such as vm property password). 
* Vault - Described in [this post](../encrypt-decrypt-and-store-sensitive-content-with-hashicorp-vault)
* Encoding - Too weak. Easy to be decode.
* Abstract algorithm - Irreversible. Not appropriate.
* Symmetric encryption - Good choice. Need to store the key in separate place. Good solution for encryption and decryption in same system. (e.g. AES)
* Asymmetric encryption - Good choice. Need to maintain 2 keys and store in separate places. It's not necessary because we have the encryption & decryption in same application. Good solution for separate encryption and decryption. (e.g. RSA)  For RSA, plain text can not be longer than the key.

|	|Maturity	|Security	|Speed	|Load	|Comment	|
|---	|---	|---	|---	|---	|---	|
|DES	|High	|Low	|Medium High	|Medium	|	|
|AES	|High	|High	|High	|Low	|Replacement of DES	|
|RSA	|High	|High	|Low	|High	|plaint text can not longger than key	|
|DSA	|High	|High	|Low	|	|Only for digital signature.	|
|ECC	|Low	|High	|High	|Low	|	|

Above all, we better choose Symmetric encryption **AES**.  And AES is faster and lower load compares to RSA.

## Resolution

The database server and application server are behind the firewall. And they are in private network. This ensures the architecture level security.

### Key

 Stores in OSS or shared NFS with authorization. Read when application started (only in memory).

### Customer Alicloud key & secret

Encrypt it before saving. Decrypt it after loading.

### Virtual Instance password in parameter

Encrypt it before saving. Decrypt it after loading.




