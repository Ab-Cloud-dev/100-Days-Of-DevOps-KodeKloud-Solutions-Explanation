# Task-27: Git Revert Some Changes

---
The Nautilus application development team has been working on a project repository `/opt/beta.git`. This repo is cloned at `/usr/src/kodekloudrepos` on `storage server` in `Stratos DC`. They recently shared the following requirements with DevOps team:  

One of the developers is working on `feature` branch and their work is still in progress, however there are some changes which have been pushed into the `master` branch, the developer now wants to `rebase` the `feature` branch with the `master` branch without loosing any data from the `feature` branch, also they don't want to add any `merge commit` by simply merging the `master` branch into the `feature` branch. Accomplish this task as per requirements mentioned.  

Also remember to push your changes once done.
---


git rebase command does. It rewrites history to create the illusion that you started your work on the latest version of the base branch (like master).

✅ **When to use:**

- You want a **clean, linear history**.
- Before merging your feature branch into `main`.
- On **local/private branches** that only you are working on (safe to rewrite).

⚠️ Don’t rebase commits that have already been pushed and shared with others (unless you coordinate and use `--force`).

# **Solution**

**Perform the Rebase**  
Rebase the feature branch onto the updated master branch. This will replay all commits from the feature branch on top of the latest master commit:


Switch to the Feature Branch
Now, switch to the feature branch that you want to rebase:

```
git checkout feature
```

```bash
git rebase master
```

This command rewinds the feature branch to the common ancestor of both branches, applies the new commits from master, and then reapplies the commits from the feature branch one by one

Since rebasing rewrites history, you must force-push the changes to the remote feature branch:
```
git push origin feature --force
```

![alt text](image.png)