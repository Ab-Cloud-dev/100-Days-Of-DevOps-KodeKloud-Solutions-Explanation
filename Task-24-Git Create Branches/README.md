# Set Up Git Repository on Storage Server

1. Utilize yum to install the git package on the Storage Server.


2. Create a bare repository named /opt/games.git (ensure exact name usage).

## Step 1: Connect to Storage Server
```bash
ssh natasha@ststor01
```

## Step 2: Configure PHP-FPM
Edit the pool configuration:
```
sudo yum install git -y
sudo mkdir -p /opt/games.git
```
it Installs Git on the server if it isn't already installed. The -y flag automatically confirms the installation.
And Creates the directory /opt/games.git where the bare repository will live. The -p flag ensures any parent directories are also created if they don't exist.



## Step 3: Initialize the repo
This is the key command. It initializes a bare Git repository in the current directory (/opt/games.git).

What is a bare repo? A bare repository doesn't have a working directory (no actual project files are checked out). It only contains the version control data (the .git folder contents). This is the recommended type for a central/shared remote repository on a server.
```bash
sudo git init --bare
```


<img width="697" height="293" alt="image" src="https://github.com/user-attachments/assets/13640645-53f5-4f02-80be-fbd1e1cb7dd8" />

