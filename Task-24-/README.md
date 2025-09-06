#  Task-24: Git Create Branches

1. On Storage server in Stratos DC create a new branch xfusioncorp_blog from master branch in /usr/src/kodekloudrepos/blog git repo.


2. Please do not try to make any changes in the code.

# Solution:

## Step 1: Connect to Storage Server
```bash
ssh natasha@ststor01
```

Had below errors

<img width="792" height="280" alt="image" src="https://github.com/user-attachments/assets/78ac4bf1-8dc5-436c-b10b-a6c10a6f36c9" />

<img width="888" height="526" alt="image" src="https://github.com/user-attachments/assets/8def160b-8162-42cc-aa9c-802e61280405" />


## Step 2: Configure PHP-FPM
Edit the pool configuration:
```
# Go to the repo
cd /usr/src/kodekloudrepos/blog

#changing the ownership for switching out to master branch 
sudo chown -R natasha:natasha /usr/src/kodekloudrepos/blog

# Make sure you are on master branch--this is to ensure = xfusioncorp_blog starts from the latest data which usually is in master/main branch
git checkout master

# Create and switch to new branch xfusioncorp_blog
git checkout -b xfusioncorp_blog
```


## Step 3: Verify 

To list the branch in repo
```bash
git branch
```

Fyi :: 
🔹 What is git checkout? 


git checkout is a command used for the following action 

1) it is used to Switch the  branches

git checkout branchname


This moves your HEAD pointer to the branch and updates your working directory with that branch’s files.

2) it is used to Create and switch to a new branch (shortcut)

git checkout -b newbranch



<img width="697" height="293" alt="image" src="https://github.com/user-attachments/assets/13640645-53f5-4f02-80be-fbd1e1cb7dd8" />

