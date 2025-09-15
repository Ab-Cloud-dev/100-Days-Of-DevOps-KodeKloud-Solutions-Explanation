# Task-25 Git Branch Management Task - Datacenter Branch Creation and Merge



1. Create a new branch `datacenter` in `/usr/src/kodekloudrepos/blog` repo from `master` and copy the `/tmp/index.html` file (present on `storage server` itself) into the repo.

2. Further, `add/commit` this file in the new branch and merge back that branch into `master` branch. Finally, push the changes to the origin for both of the branches.

# **Solution**


## Make sure you elevate to root and proceed with the below steps otherwise the system wouldn't accept it 

```
sudo su -
```

## **1. `cd /usr/src/kodekloudrepos/blog/`**

- **Change Directory** to the specified path
  
- Navigates to the blog repository folder
  

## **2. `ls -la`**

- **List** files and directories with **long format** and **show all** (including hidden files)
  
- Used to see the current state of the repository
  

## **3. `cp /tmp/index.html .`**

- **Copy** the `index.html` file from `/tmp/` directory to the **current directory** (`.`)
  
- Adds a new file to the repository
  

## **4. `git checkout -b datacenter`**

- **Create and switch** to a new branch called "datacenter"
  
- `-b` flag creates the branch if it doesn't exist
  

## **5. `git add .`**

- **Stage** all changes in the current directory for commit
  
- The `.` means "all files in current directory and subdirectories"
  

## **6. `git status`**

- **Show** the current state of the working directory and staging area
  
- Displays which files are staged, unstaged, or untracked
  

## **7. `git commit -m "Add index.html file to datacenter branch"`**

- **Commit** the staged changes with a descriptive message
  
- Creates a permanent snapshot of the changes in the branch
  

## **8. `git push origin datacenter`**

- **Push** the "datacenter" branch to the remote repository called "origin"
  
- Makes the branch available on the remote server (like GitHub/GitLab)
  

## **9. `git checkout master`**

- **Switch** back to the main "master" branch

## **10. `git status`**

- **Check status** again to ensure working directory is clean before merging

## **11. `git merge datacenter`**

- **Merge** the "datacenter" branch into the current branch ("master")
  
- Incorporates changes from datacenter branch into master
  

## **12. `git push origin master`**

- **Push** the updated master branch to the remote repository
  
- Makes the merged changes available remotely
  

## **13. `history`**

- **Display** the command history for the current session
  
- Shows all commands executed in the terminal
  
<img width="853" height="830" alt="image" src="https://github.com/user-attachments/assets/f4324388-43b6-4e0d-a0ba-d727d23ccaa2" />

## **Summary:**

This sequence demonstrates a complete Git workflow:

1. Created and worked on a feature branch ("datacenter")
  
2. Added a new file and committed it
  
3. Merged the feature branch back into master
  
4. Pushed all changes to the remote repository
  

This is a common pattern for implementing new features while keeping the main branch stable.
