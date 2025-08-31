 #Task: Create user 'yousuf' with non-interactive shell on App Server 3
 
## From jump_host, connect to stapp03 (App Server 3)

## Step 1: SSH to App Server 3
ssh banner@stapp03.stratos.xfusioncorp.com

## Step 2: Switch to root user (if needed for user creation)
sudo su -

## Step 3: Create user 'yousuf' with non-interactive shell
### Using /sbin/nologin as the non-interactive shell
useradd -s /sbin/nologin yousuf

## Step 4: Verify the user creation
### Check if user exists in /etc/passwd
grep yousuf /etc/passwd

## Step 5: Verify the shell assignment
### The output should show /sbin/nologin as the shell
id yousuf

## Alternative verification - check user details
getent passwd yousuf

<img width="948" height="438" alt="image" src="https://github.com/user-attachments/assets/a5513407-15d6-4248-83ce-61eeeee18cb6" />

# Key Points:

- The -s /sbin/nologin option assigns a non-interactive shell to the user
- /sbin/nologin prevents the user from logging in interactively while still allowing the account to exist for system processes
- This is commonly used for service accounts and backup agents that need to exist but shouldn't have shell access

- The user yousuf is now created with a non-interactive shell as requested for the backup agent tool specifications.RetryClaude can make mistakes. Please double-check responses.
