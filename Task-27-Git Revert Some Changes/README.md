# Task-25 Git Branch Management Task - Datacenter Branch Creation and Merge



1. Create a new branch `datacenter` in `/usr/src/kodekloudrepos/demo` repo from `master` and copy the `/tmp/index.html` file (present on `storage server` itself) into the repo.

2. Further, `add/commit` this file in the new branch and merge back that branch into `master` branch. Finally, push the changes to the origin for both of the branches.

# **Solution**



## Step 1: Connect to Storage Server

```bash
# From jump_host, SSH to storage server
ssh natasha@ststor01.stratos.xfusioncorp.com
# Password: Bl@kW
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

## Step 3: Create and Switch to New Branch 'datacenter'

```bash
# Create a new branch called 'datacenter' from master
git checkout -b datacenter

# Verify you're on the new branch
git branch
git status
```

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

# Verify the commit
git log --oneline -n 3
```

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

## Step 8: Push Changes to Origin

```bash
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
git pull origin master  # Get latest changes

# Create and work on datacenter branch
git checkout -b datacenter
cp /tmp/index.html .
git add index.html
git commit -m "Add index.html file to datacenter branch"

# Merge back to master
git checkout master
git merge datacenter

# Push both branches
git push origin master
git push origin datacenter
```

## Verification Commands

```bash
# Check repository status
git status

# View commit history
git log --oneline --graph --all

# List all branches (local and remote)
git branch -a

# Verify file exists in both branches
git checkout master && ls -la index.html
git checkout datacenter && ls -la index.html

# Check remote repository status
git remote -v
git ls-remote origin
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

### If remote origin is not set:

```bash
# Check current remote
git remote -v

# Add origin if missing (replace with actual repo URL)
git remote add origin <repository-url>
```

### If merge conflicts occur:

```bash
# Check conflict status
git status

# View conflicted files
git diff

# After resolving conflicts manually
git add .
git commit -m "Resolve merge conflicts"
```

## Expected Final State

After completing all steps:

1. ✅ `datacenter` branch created from `master`
2. ✅ `/tmp/index.html` copied to repository
3. ✅ File added and committed in `datacenter` branch
4. ✅ `datacenter` branch merged back into `master`
5. ✅ Both branches pushed to origin
6. ✅ `index.html` file exists in both branches

## Verification Commands to Confirm Success

```bash
# Final verification
git branch -a  # Should show both local and remote branches
git log --oneline --graph --all  # Should show merge history
ls -la index.html  # File should exist
git show HEAD  # Should show the merge commit or the file addition
```

The task should now be complete with the datacenter branch created, file added, merged back to master, and both branches pushed to origin!