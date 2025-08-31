# Task 07: Linux SSH Authentication

## Objective

Setting up password-less SSH authentication from user thor on the jump host to the app server 

## Overview

This process involves generating an SSH key pair for thor, copying the public key to the target app server's sudo user (e.g., tony) authorized_keys file, and testing the connection. The goal is to allow thor to SSH as tony@172.16.238.10 without a password

## Step-by-Step Solution


### Step 1: Generate an SSH key pair for thor without a passphrase and saves the private/public key to Key store of thor user.


```bash
ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
```

<img width="1231" height="895" alt="image" src="https://github.com/user-attachments/assets/8e74e7da-6eba-478f-ab8b-73dfe4f48e2d" />


### Step 2: Copy the public key to the app server's sudo user:

Use ssh-copy-id to copy thor's public key to tony's authorized_keys file while bypassing host key verification prompts. 

```bash

ssh-copy-id -o StrictHostKeyChecking=no  tony@172.16.238.10

```

You will be prompted for tony's password on the app server. Enter it to allow the key copy.

This command automatically appends the public key to ~tony/.ssh/authorized_keys on the app server, creating the .ssh directory and setting correct permissions if necessary

### Step 4: Test password-less SSH access:
From the jump host, try SSHing as tony to the app server:

```bash
ssh tony@172.16.238.10
```

<img width="1532" height="453" alt="image" src="https://github.com/user-attachments/assets/0be84a3b-2657-4394-886d-a63d1a4cbe68" />


Now, you should log in without a password prompt

## What can be achieve from this 

All without any password prompts 

- ✅ Automated backups: Scripts can securely copy files between servers without manual password entry
- ✅ Bulk server management: Admins can execute commands on multiple servers simultaneously
- ✅ SSH to web server and pull latest code
