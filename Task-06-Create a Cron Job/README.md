# Task 03:  Install cronie package on all Nautilus app

## Objective

Scheduling the echo command every 5 minutes as the root user.

## Step-by-Step Solution


 Install cronie package 
 
```bash
sudo yum install cronie -y
```


### Step 2: Start and enable crond service

```bash
sudo systemctl start crond          # Start the service
sudo systemctl enable crond         # Enable auto-start on boot
sudo systemctl status crond         # Verify service is active
```

### Step 3: Add the cron job for root user


```bash
sudo crontab -e -u root
```
This opens the root user's crontab file in the default editor. Add the following line:

```bash
*/5 * * * * echo hello > /tmp/cron_text
```

### Verify the cron job

This lists all cron jobs for the root user, confirming your entry was added

```bash
sudo crontab -l -u root
```

### 5. Check execution (after 5 minutes)



## Key Notes:

The cron expression */5 * * * * means "every 5 minutes".

The output redirection > /tmp/cron_text overwrites the file each time. Use >> /tmp/cron_text to append instead.

Cron jobs run with the user's permissions (here, root), so ensure root has write access to /tmp/ .

Logs can be checked at /var/log/cron* or with journalctl -u crond.service for troubleshooting