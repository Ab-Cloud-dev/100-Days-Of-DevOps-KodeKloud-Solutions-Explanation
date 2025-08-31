# Task 02: Disable Direct SSH Root Login on All App Servers

## Objective

Setting permision on /tmp/xfusioncorp.sh 




The file /tmp/xfusioncorp.sh has no permissions set for any user (owner, group, or others), as indicated by the permission bits ----------. This means even the root user cannot execute, read, or write to it directly through normal means. 
However, since you are root (as shown by the ownership root root), you can change the permissions to make it usable.


## First Read the permision of the file 


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


## Verification Steps

Execute the Script as a Non-Root User
Now any user can run the script with:

```bash
/tmp/xfusioncorp.sh
```