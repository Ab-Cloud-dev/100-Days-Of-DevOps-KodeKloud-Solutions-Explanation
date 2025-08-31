# Task 02: Disable Direct SSH Root Login on All App Servers

## Objective

Setting permission on /tmp/xfusioncorp.sh 


## First Read the permision of the file 

<img width="688" height="90" alt="image" src="https://github.com/user-attachments/assets/87af953c-ee26-44e2-a96f-9ad3e6548b99" />

The file /tmp/xfusioncorp.sh has no permissions set for any user (owner, group, or others), as indicated by the permission bits ----------. This means even the root user cannot execute, read, or write to it directly through normal means. 
However, since you are root (as shown by the ownership root root), you can change the permissions to make it usable.

# Solution

Add Read and Execute Permissions (Recommended for a Script)

```bash
sudo chmod 755 /tmp/xfusioncorp.sh
```
This will give:

Owner (root): read, write, execute (7)

Group: read, execute (5)

Others: read, execute (5)


<img width="712" height="315" alt="image" src="https://github.com/user-attachments/assets/f1148766-a161-44e2-92a6-a4b6f9c82306" />



## Verification Steps

Execute the Script as a Non-Root User
Now any user can run the script with:

```bash
/tmp/xfusioncorp.sh
```



## What This Achieves:

- ✅ Giving execution permission to other users (making the script executable by everyone)
- ✅ Users still cannot modify the script (unless you also give write permissions)
