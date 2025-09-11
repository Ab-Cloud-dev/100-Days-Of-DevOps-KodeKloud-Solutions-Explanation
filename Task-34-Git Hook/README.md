# Task-28:  Git Cherry Pick
---

The Nautilus application development team was working on a git repository `/opt/beta.git` which is cloned under `/usr/src/kodekloudrepos` directory present on `Storage server` in `Stratos DC`. The team want to setup a hook on this repository, please find below more details:  

- Merge the `feature` branch into the `master` branch`, but before pushing your changes complete below point.
- Create a `post-update` hook in this git repository so that whenever any changes are pushed to the `master` branch, it creates a release tag with name `release-2023-06-15`, where `2023-06-15` is supposed to be the current date. For example if today is `20th June, 2023` then the release tag must be `release-2023-06-20`. Make sure you test the hook at least once and create a release tag for today's release.
- Finally remember to push your changes.  
`Note:` Perform this task using the `natasha` user, and ensure the repository or existing directory permissions are not altered.

---

# First we will try to understand what is Git Hook

## What are Git Hooks?

Git hooks are **scripts that Git executes automatically** at specific points during Git operations. They allow you to customize Git's behavior and automate tasks when certain events occur in your repository.

## Post-Update Hook Specifically

The **post-update hook** is a **server-side hook** that runs **after** a successful push operation to a Git repository. Here's what you need to know:

### When it runs:

- **After** `git push` completes successfully
- **After** all references (branches/tags) have been updated
- Only runs on the **receiving repository** (the one being pushed to)

### Common use cases:

1. **Deployment automation** - Deploy code after push to production branch
2. **Notifications** - Send emails/Slack messages about updates
3. **Tag creation** - Automatically create release tags
4. **Documentation updates** - Regenerate docs when code changes
5. **CI/CD triggers** - Start build processes
6. **Backup operations** - Create backups after updates

---


# **Solution**
