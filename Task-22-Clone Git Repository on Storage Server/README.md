# Task-22: Clone Git Repository on Storage Server

1. The repository to be cloned is located at /opt/blog.git


2. Clone this Git repository to the /usr/src/kodekloudrepos directory. Perform this task using the natasha user, and ensure that no modifications are made to the repository or existing directories, such as changing permissions or making unauthorized alterations.


## Step 1: Connect to Storage Server
```bash
ssh natasha@ststor01
```

## Step 2: Configure PHP-FPM
Edit the pool configuration:
```
cd /usr/src/kodekloudrepos/
sudo git clone /opt/blog.git
```
<img width="862" height="546" alt="image" src="https://github.com/user-attachments/assets/69a816d1-83cb-482e-b7eb-96ca861fc4da" />


Fyi:: Cloning in Git means creating a complete copy of an existing repository—including all files, history, and branches—onto a local machine from a remote or local source using the git clone command.

#Typical Use Cases::

Collaborating on projects by getting a development copy from platforms like GitHub, GitLab, or Bitbucket.

Working offline and later synchronizing changes back to the remote repository.

Backing up or migrating repositories.
