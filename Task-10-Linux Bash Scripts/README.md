# Task 02: MariaDb Troubleshooting

## Objective

a. Create a zip archive named xfusioncorp_news.zip of /var/www/html/news directory.


b. Save the archive in /backup/ on App Server 1. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.


c. Copy the created archive to Nautilus Backup Server server in /backup/ location.


d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.


e. Do not use sudo inside the script.


## Step-by-Step Solution



#### Step 1: From Appserver01 Creating SSh Key for passwordLess login to backup Server And Installing Zip


```bash
ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
ssh-copy-id -o StrictHostKeyChecking=no  clint@stbkp01
sudo yum install zip -y
```



#### Step 2: Making an Scripts as per Objectives

```bash
vi /scripts/news_backup.sh
chmod +x /scripts/news_backup.sh 
```
news_backup.sh contains below
```
#!/bin/bash
zip -r /backup/xfusioncorp_news.zip /var/www/html/news 

scp /backup/xfusioncorp_news.zip clint@stbkp01:/backup
```
<img width="1475" height="987" alt="image" src="https://github.com/user-attachments/assets/d3394c52-cc71-40a3-8142-af77301b33f0" />


#### Step 3: Running the Script

```bash
sh /scripts/news_backup.sh 
```


<img width="1606" height="200" alt="image" src="https://github.com/user-attachments/assets/41f26693-d7cd-4c07-951f-55c37c544e26" />

