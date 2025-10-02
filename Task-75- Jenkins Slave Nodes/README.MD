1. Add all app servers as SSH build agent/slave nodes in Jenkins. Slave node name for `app server 1`, `app server 2` and `app server 3` must be `App_server_1`, `App_server_2`, `App_server_3` respectively.

2. Add labels as below:

`App_server_1 : stapp01`

`App_server_2 : stapp02`

`App_server_3 : stapp03`

3. Remote root directory for `App_server_1` must be `/home/tony/jenkins`, for `App_server_2` must be `/home/steve/jenkins` and for `App_server_3` must be `/home/banner/jenkins`.

4. Make sure slave nodes are online and working properly.

---

# Solution:

First Kindly ensure below plugin installed

![alt text](image-3.png)

![alt text](image-4.png)

## Step 1: Prepare App Servers (SSH Keys Setup)

First, let's set up SSH access from Jenkins to all app servers.

### From Jump Host, SSH to Jenkins Server:

```bash
ssh jenkins@172.16.238.19
# Password: j@rv!s
```

### Switch to Jenkins User and Create SSH Keys:

```bash
sudo su - jenkins
ssh-keygen -t rsa -b 2048 -N ""



```

**Copy the output** - you'll need this public key.

### Add Jenkins Public Key to Each App Server:

```bash
# Still as jenkins user on Jenkins server

# Add key to App Server 1 (stapp01)
ssh-copy-id -o StrictHostKeyChecking=no tony@172.16.238.10
# Password: Ir0nM@n

# Add key to App Server 2 (stapp02)
ssh-copy-id -o StrictHostKeyChecking=no steve@172.16.238.11
# Password: Am3ric@

# Add key to App Server 3 (stapp03)
ssh-copy-id -o StrictHostKeyChecking=no banner@172.16.238.12
# Password: BigGr33n
```

### Test SSH Connections:

```bash
# Test all connections
ssh tony@172.16.238.10 "hostname && echo 'stapp01 connection successful'"
ssh steve@172.16.238.11 "hostname && echo 'stapp02 connection successful'"
ssh banner@172.16.238.12 "hostname && echo 'stapp03 connection successful'"
```
![alt text](image.png)

### Create Jenkins Directories on App Servers:

```bash
# Create directories with proper permissions
ssh tony@172.16.238.10 "mkdir -p /home/tony/jenkins && chmod 755 /home/tony/jenkins"
ssh steve@172.16.238.11 "mkdir -p /home/steve/jenkins && chmod 755 /home/steve/jenkins"
ssh banner@172.16.238.12 "mkdir -p /home/banner/jenkins && chmod 755 /home/banner/jenkins"

# Verify directories
ssh tony@172.16.238.10 "ls -ld /home/tony/jenkins"
ssh steve@172.16.238.11 "ls -ld /home/steve/jenkins"
ssh banner@172.16.238.12 "ls -ld /home/banner/jenkins"
```

### Install Java on App Servers (Required for Jenkins Agents):

```bash
# Install Java on stapp01
ssh tony@172.16.238.10 " echo "Ir0nM@n" | sudo -S  yum install -y java-17-openjdk"

# Install Java on stapp02
ssh steve@172.16.238.11 "echo "Am3ric@" | sudo -S  yum install -y java-17-openjdk"

# Install Java on stapp03
ssh banner@172.16.238.12 " echo "BigGr33n" | sudo -S yum install -y java-17-openjdk"

# Verify Java installation
ssh tony@172.16.238.10 "java -version"
ssh steve@172.16.238.11 "java -version"
ssh banner@172.16.238.12 "java -version"
```
![alt text](image-1.png)

---

## Step 2: Add SSH Credentials in Jenkins (GUI Method)

# Display the public key (we'll need this)
```
cat ~/.ssh/id_rsa.pub
```

### Access Jenkins Web UI:


### Add SSH Private Key Credential: For all three servers one by one

1. **Manage Jenkins** → **Manage Credentials**
2. Click **System** → **Global credentials (unrestricted)**
3. Click **+ Add Credentials**

**Fill in the form:**
- **Kind:** SSH Username with private key
- **Scope:** Global
- **ID:** `tony-ssh` / `steve-ssh` / `banner-ssh`
- **Description:** `Jenkins SSH key for app servers01 / app servers-02 /app servers 03`
- **Username:** (tony / steve / banner)
- **Private Key:**
  - Select **Enter directly**
  - Click **Add**
  - Paste the content of Jenkins private key (cat ~/.ssh/id_rsa)
![alt text](image-5.png)
To get the private key, run this from jump_host:
```bash
ssh jenkins@172.16.238.19 "sudo cat /var/lib/jenkins/.ssh/id_rsa"
```

Copy the entire output (including `-----BEGIN OPENSSH PRIVATE KEY-----` and `-----END OPENSSH PRIVATE KEY-----`) and paste it.

- **Passphrase:** (leave empty)
- Click **Create**

---

## Step 3: Add App Server 1 as Jenkins Node (GUI Method)

### Navigate to Nodes:

1. **Dashboard** → **Manage Jenkins**
2. Click **Manage Nodes and Clouds** (or **Nodes**)
3. Click **New Node** (left sidebar)

### Configure App Server 1:

**Step 1: Create Node**
- **Node name:** `App_server_1`
- Select **Permanent Agent**
- Click **Create**

**Step 2: Configure Node Settings**

- **Name:** `App_server_1` (already filled)
- **Description:** `Nautilus App Server 1 (stapp01)`
- **Number of executors:** `2`
- **Remote root directory:** `/home/tony/jenkins`
- **Labels:** `stapp01`
- **Usage:** Use this node as much as possible
- **Launch method:** Launch agents via SSH

**SSH Launch Configuration:**
- **Host:** `172.16.238.10`
- **Credentials:**
   - Now select `tony-ssh` from the dropdown

- **Host Key Verification Strategy:** Non verifying Verification Strategy
- **JavaPath:** (leave empty - will auto-detect)

**Availability:** Keep this agent online as much as possible

- Click **Save**

---

## Step 4: Add App Server 2 as Jenkins Node

1. **Dashboard** → **Manage Jenkins** → **Manage Nodes and Clouds**
2. Click **New Node**

### Configure App Server 2:

- **Node name:** `App_server_2`
- Select **Permanent Agent**
- Click **Create**

**Configure:**
- **Description:** `Nautilus App Server 2 (stapp02)`
- **Number of executors:** `2`
- **Remote root directory:** `/home/steve/jenkins`
- **Labels:** `stapp02`
- **Usage:** Use this node as much as possible
- **Launch method:** Launch agents via SSH

**SSH Configuration:**
- **Host:** `172.16.238.11`
- **Credentials:**

  - Select `steve-ssh`

- **Host Key Verification Strategy:** Non verifying Verification Strategy

- Click **Save**

---

## Step 5: Add App Server 3 as Jenkins Node

1. **Dashboard** → **Manage Jenkins** → **Manage Nodes and Clouds**
2. Click **New Node**

### Configure App Server 3:

- **Node name:** `App_server_3`
- Select **Permanent Agent**
- Click **Create**

**Configure:**
- **Description:** `Nautilus App Server 3 (stapp03)`
- **Number of executors:** `2`
- **Remote root directory:** `/home/banner/jenkins`
- **Labels:** `stapp03`
- **Usage:** Use this node as much as possible
- **Launch method:** Launch agents via SSH

**SSH Configuration:**
- **Host:** `172.16.238.12`
- **Credentials:**

  - Select `banner-ssh`

- **Host Key Verification Strategy:** Non verifying Verification Strategy

- Click **Save**

---

## Step 6: Verify All Nodes are Online

1. Go to **Dashboard** → **Manage Jenkins** → **Manage Nodes and Clouds**

You should see:
![alt text](image-2.png)

All nodes should show as **online** with a green indicator.

### If a Node Shows Offline:

Click on the node name, then:
- Check **Log** for error messages
- Click **Launch agent** to manually connect
- Verify SSH connectivity from Jenkins server

---

---


## Summary

✅ **App_server_1** → `/home/tony/jenkins` → Label: `stapp01`
✅ **App_server_2** → `/home/steve/jenkins` → Label: `stapp02`
✅ **App_server_3** → `/home/banner/jenkins` → Label: `stapp03`

All nodes should now be:
- ✅ Online and synchronized
- ✅ Ready to execute builds
- ✅ Properly labeled
- ✅ Using correct remote directories

Let me know if any node shows offline or if you encounter any issues!
