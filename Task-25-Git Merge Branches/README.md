# Task-25 Git Branch Management Task - Datacenter Branch Creation and Merge



1. Create a new branch `datacenter` in `/usr/src/kodekloudrepos/demo` repo from `master` and copy the `/tmp/index.html` file (present on `storage server` itself) into the repo.

2. Further, `add/commit` this file in the new branch and merge back that branch into `master` branch. Finally, push the changes to the origin for both of the branches.

# **Solution**


## Step 1: Connect to Storage Server

```bash
# From jump_host, SSH to storage server
ssh natasha@ststor01
```

## Step 2: Navigate to the Repository

```bash
# Change to the repository directory
cd /usr/src/kodekloudrepos/demo

# Verify you're in the correct repository
pwd
ls -la

# Check current Git status and branch
git status
git branch -a
```

<img width="860" height="254" alt="image" src="https://github.com/user-attachments/assets/3aee618b-c413-48bc-9f1d-9823ff5e3950" />




Git is refusing because of “dubious ownership” — meaning the repo /usr/src/kodekloudrepos/demo is owned by a different user than natasha.

Our aim is to create a branch, add index.html, merge, and push.


<img width="773" height="122" alt="image" src="https://github.com/user-attachments/assets/667ec327-d3fa-4771-983d-5578a667c8ba" />

```
git config --global --add safe.directory /usr/src/kodekloudrepos/demo
```


This Commands tell git that a specific repo is safe. Even though ownership doesn’t match, go ahead and let me work here.

Even though you marked it “safe” in Git, the OS still enforces file permissions. it is best to take ownership of the Files


<img width="790" height="483" alt="image" src="https://github.com/user-attachments/assets/b34cab25-9788-48a4-a9ee-61f4b34e60b0" />

```
sudo chown -R natasha:natasha /usr/src/kodekloudrepos/demo
ls -la
```

## Step 3: Creating and Switching to New Branch 'datacenter'

```bash
# Create a new branch called 'datacenter' from master
git checkout -b datacenter

# Verify you're on the new branch
git branch
git status
```
<img width="533" height="119" alt="image" src="https://github.com/user-attachments/assets/f117eaa6-954a-44d6-a701-6b8a30433c69" />

## Step 4: Copy the index.html File

```bash
# Copy the index.html file from /tmp to the current repository directory
cp /tmp/index.html .

# Verify the file was copied
ls -la index.html
cat index.html  # Optional: view the content
```

## Step 5: Add and Commit the File

```bash
# Add the file to staging area
git add index.html

# Check the status to confirm file is staged
git status

# Commit the file with a descriptive message
git commit -m "Add index.html file to datacenter branch"
```
<img width="795" height="612" alt="image" src="https://github.com/user-attachments/assets/08065188-6ef9-408c-8500-27fb35a857bd" />

It seems we need to confirm the identity to the Git for making an commit. Since we are working as natasha user, it will be best to set natasha user globally( means for all repos)

```
git config --global user.name "natasha"
```
```
# Commit the file with a descriptive message
git commit -m "Add index.html file to datacenter branch"
# Verify the commit
git log --oneline -n 3
```

<img width="694" height="82" alt="image" src="https://github.com/user-attachments/assets/a55370bd-8a80-45bc-992d-bd8d04e01e23" />



## Step 6: Switch Back to Master Branch

```bash
# Switch back to master branch
git checkout master

# Verify you're on master branch
git branch
git status
```

## Step 7: Merge datacenter Branch into Master

```bash
# Merge the datacenter branch into master
git merge datacenter

# Verify the merge was successful
git log --oneline -n 5
ls -la  # Should now see index.html in master branch
```

<img width="912" height="501" alt="image" src="https://github.com/user-attachments/assets/3d46462f-6e67-4ae9-8b60-8e65514806a2" />

## Step 8: Push Changes to Origin

```bash
#First changing the permision as is likely owned by root (or another user).So Git cannot create the temporary object directories there.
sudo chown -R natasha:natasha /opt/demo.git
# Push the master branch to origin
git push origin master

# Push the datacenter branch to origin
git push origin datacenter

# Verify both branches are pushed
git branch -r  # Shows remote branches
```

## Complete Command Sequence (Alternative)

If you prefer to run commands in sequence:

```bash
# Connect to storage server
ssh natasha@ststor01.stratos.xfusioncorp.com

# Navigate and setup
cd /usr/src/kodekloudrepos/demo
git checkout master  # Ensure we're on master
sudo chown -R natasha:natasha /usr/src/kodekloudrepos/demo/
git config --global user.name "natasha"

# Create and work on datacenter branch
git checkout -b datacenter
cp /tmp/index.html .
git add index.html
git commit -m "Add index.html file to datacenter branch"

# Merge back to master
git checkout master
git merge datacenter

# Push both branches
sudo chown -R natasha:natasha /opt/demo.git
git push origin master
git push origin datacenter
```


## Troubleshooting Tips

### If you encounter permission issues:

```bash
# Check file permissions
ls -la /tmp/index.html

# If needed, change ownership (run as root or with sudo)
sudo chown natasha:natasha /tmp/index.html
```

### If Git repository needs configuration:

```bash
# Set Git user configuration if needed
git config user.name "natasha"
git config user.email "natasha@stratos.xfusioncorp.com"

# Or set globally
git config --global user.name "natasha"
git config --global user.email "natasha@stratos.xfusioncorp.com"
```

## Expected Final State

After completing all steps:

1. ✅ `datacenter` branch created from `master`
2. ✅ `/tmp/index.html` copied to repository
3. ✅ Changing the Permission of the Files so as to create a new Branch
4. ✅ File added and committed in `datacenter` branch
5. ✅ `datacenter` branch merged back into `master`
6. ✅ Both branches pushed to origin
7. ✅ `index.html` file exists in both branches

## Verification Commands to Confirm Success

```bash
# Final verification
git show HEAD  # Should show the merge commit or the file addition
```
<img width="727" height="293" alt="image" src="https://github.com/user-attachments/assets/aa540ca2-af05-4365-a384-d1a12a6e1ee9" />

The git show HEAD command displays detailed information about the commit that HEAD currently points to. HEAD is a symbolic reference in Git that typically points to the tip of the currently checked-out branch.


The task should now be complete with the datacenter branch created, file added, merged back to master, and both branches pushed to origin!
