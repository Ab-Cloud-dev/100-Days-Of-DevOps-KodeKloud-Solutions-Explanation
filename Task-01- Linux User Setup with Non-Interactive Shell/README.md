 # Task: Create user 'yousuf' with non-interactive shell on App Server 3
 
## Solution Steps

### Step 1: Connect to App Server 3
From the jump_host, SSH to App Server 3:
```bash
ssh banner@stapp03.stratos.xfusioncorp.com
```


### Step 2: Switch to Root Privileges
```bash
sudo su -
```

### Step 3: Create User with Non-Interactive Shell
Create the user `yousuf` with `/sbin/nologin` as the shell:
```bash
useradd -s /sbin/nologin yousuf
```

### Step 4: Verify User Creation
Check if the user was created successfully:
```bash
grep yousuf /etc/passwd
```


<img width="948" height="438" alt="image" src="https://github.com/user-attachments/assets/a5513407-15d6-4248-83ce-61eeeee18cb6" />

## Key Points

### About Non-Interactive Shell (`/sbin/nologin`)
- **Purpose:** The user yousuf is now created with a non-interactive shell as requested for the backup agent tool specifications
- **Use Case:** Ideal for service accounts, backup agents, and system processes
- **Security:** User cannot log in via SSH or console but can be used by applications


## Task Completion
✅ User `yousuf` created successfully on App Server 3  
✅ Non-interactive shell (`/sbin/nologin`) assigned  
✅ Suitable for backup agent tool specifications  
