# Task 02: Disable Direct SSH Root Login on All App Servers

## Objective

Disable direct SSH root login on all app servers (stapp01, stapp02, stapp03) to enhance security by preventing direct root access via SSH.



# Solution Overview

We need to modify the SSH configuration file `/etc/ssh/sshd_config` on each app server to set `PermitRootLogin no`.

Backup SSH Configuration

```bash
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

```bash
vi /etc/ssh/sshd_config
```

Find the line with `PermitRootLogin` and change it to:

```
PermitRootLogin no
```

If the line is commented out (starts with #), uncomment it and set to `no`. 

Restart SSH Service

```bash
systemctl restart sshd
```

# Alternate Solution


For each server, you can also use the `sed` command to make the change:

```bash
# Backup the file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Replace or add PermitRootLogin no
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# If the line doesn't exist, add it
grep -q "^PermitRootLogin" /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Restart SSH service
systemctl restart sshd
```

## Verification Steps

After completing the configuration on all servers, verify that root login is disabled:


```bash
# On each server, check the configuration
grep "PermitRootLogin" /etc/ssh/sshd_config
```

**Expected Output:**

```
PermitRootLogin no
```

## What This Achieves:

- ✅ Prevents direct SSH login as root user
- ✅ Prevents direct brute force attempts on the root account
- ✅ Encourages using named user accounts for better accountability.
- ✅ Aligns with security best practices and compliance standards.