# Task-22: Clone Git Repository on Storage Server

1. The repository to be cloned is located at /opt/demo.git


2. Clone this Git repository to the /usr/src/kodekloudrepos directory. Perform this task using the natasha user, and ensure that no modifications are made to the repository or existing directories, such as changing permissions or making unauthorized alterations.


## Step 1: Connect to Storage Server
```bash
ssh natasha@ststor01
```

## Step 2: Configure PHP-FPM
Edit the pool configuration:
```
cd /opt/
chown -R natasha:natasha /opt/demo.git
cd /usr/src/kodekloudrepos/
sudo git clone /opt/demo.git
```
<img width="879" height="768" alt="image" src="https://github.com/user-attachments/assets/e1393fbb-f7b8-48ce-96e7-fa87125a9a78" />


There are no commits for the repo  /opt/demo.git, the clone will succeed but the working directory (/usr/src/kodekloudrepos) will look empty except for the .git/ folder.

That’s why earlier you saw only .git/ and no files. The warning: **You appear to have cloned an empty repository** message is just Git telling you “the repo is valid, but it has no commits yet.”

So cloning an empty repo is completely valid and is probably what your task expected you to do ✅.


Fyi:: Cloning in Git means creating a complete copy of an existing repository—including all files, history, and branches—onto a local machine from a remote or local source using the git clone command.

#Typical Use Cases::

Collaborating on projects by getting a development copy from platforms like GitHub, GitLab, or Bitbucket.

Working offline and later synchronizing changes back to the remote repository.

Backing up or migrating repositories.
