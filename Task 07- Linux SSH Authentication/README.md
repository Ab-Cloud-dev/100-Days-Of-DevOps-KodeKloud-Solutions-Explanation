# Task 07: Linux SSH Authentication

## Objective

Setting up password-less SSH authentication from user thor on the jump host to the app server 

## Overview

This process involves generating an SSH key pair for thor, copying the public key to the target app server's sudo user (e.g., tony) authorized_keys file, and testing the connection. The goal is to allow thor to SSH as tony@172.16.238.10 without a password

## Step-by-Step Solution


### Step 1: Generate an SSH key pair for thor


```bash
ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
```



### Step 2: Copy the public key to the app server's sudo user:

Use ssh-copy-id to copy thor's public key to tony's authorized_keys file

```bash

ssh-keygen -t rsa  ssh-copy-id -o StrictHostKeyChecking=no  tony@172.16.238.10

```

You will be prompted for tony's password on the app server. Enter it to allow the key copy.

This command automatically appends the public key to ~tony/.ssh/authorized_keys on the app server, creating the .ssh directory and setting correct permissions if necessary

### Step 4: Test password-less SSH access:
From the jump host, try SSHing as tony to the app server:

```bash
ssh tony@172.16.238.10
```

Now, you should log in without a password prompt

## What can be achieve from this 

All without any password prompts 

- ✅ Automated backups: Scripts can securely copy files between servers without manual password entry
- ✅ Bulk server management: Admins can execute commands on multiple servers simultaneously
- ✅ SSH to web server and pull latest code