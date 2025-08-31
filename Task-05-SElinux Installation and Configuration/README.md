# Task 05: SELinux Management on App Server 2

## Objective
1. Install the required SELinux packages on App Server 2
2. Permanently disable SELinux for temporary configuration changes
3. Ensure SELinux status will be `disabled` after the scheduled reboot



## Step-by-Step Solution

### Step 1: Connect to App Server 2
From the jump_host, SSH to App Server 2:
```bash
ssh steve@stapp02.stratos.xfusioncorp.com
```


## Step 3: Check Current SELinux Status (Optional)
Before making changes, check the current status :
```bash
sestatus
```


## Step 4: Install Required SELinux Packages
Install the essential SELinux packages:


```bash

sudo yum install -y policycoreutils selinux-policy selinux-policy-targeted

```

<img width="1434" height="531" alt="image" src="https://github.com/user-attachments/assets/fac77488-6d7c-4921-a55a-c7fd9d12f94f" />

**Package Descriptions:**
- `selinux-policy`: Core SELinux policy
- `selinux-policy-targeted`: Targeted policy (most common)
- `policycoreutils`: SELinux policy core utilities



### Step 5: Verify Package Installation
Check if the packages were installed successfully:
```bash
rpm -qa | grep selinux
rpm -qa | grep policycoreutils
```


## Step 6: Permanently Disable SELinux
Edit the SELinux configuration file to permanently disable it:

First take Backup
```bash
cp /etc/selinux/config /etc/selinux/config.backup
```

Edit the configuration file:

```bash
vi /etc/selinux/config
```

or use sed command

**Change the following line:**
```bash
# From:
SELINUX=enforcing
# or
SELINUX=permissive

# To:
SELINUX=disabled
```


## Verification Steps

### Current Status Check (Before Reboot)
Even though we're disregarding the current command-line status, you can verify the configuration:

Configuration file and sestatus should show SELINUX=disabled


<img width="557" height="179" alt="image" src="https://github.com/user-attachments/assets/1912ebad-465f-4a47-9b4e-be36c8485428" />



```bash


grep "^SELINUX=" /etc/selinux/config
sestatus
```


### Package Installation Benefits
- **Complete toolset**: All necessary SELinux tools are available
- **Future re-enabling**: Easy to re-enable SELinux when needed
- **Policy management**: Complete policy management capabilities

What is SELinux?

Security-Enhanced Linux (SELinux) is a security architecture for Linux® systems that allows administrators to have more control over who can access the system
https://www.redhat.com/en/topics/linux/what-is-selinux
