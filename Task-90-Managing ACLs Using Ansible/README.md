# Task-91 Managing ACLs Using Ansible

Create a playbook named `playbook.yml` under `/home/thor/ansible` directory on `jump host`, an `inventory` file is already present under `/home/thor/ansible` directory on `Jump Server` itself.

1. Create an empty file `blog.txt` under `/opt/security/` directory on app server 1. Set some `acl` properties for this file. Using `acl` provide `read '(r)'` permissions to `group tony` (i.e `entity` is `tony` and `etype` is `group`).
2. Create an empty file `story.txt` under `/opt/security/` directory on app server 2. Set some `acl` properties for this file. Using `acl` provide `read + write '(rw)'` permissions to `user steve` (i.e `entity` is `steve` and `etype` is `user`).
3. Create an empty file `media.txt` under `/opt/security/` on app server 3. Set some `acl` properties for this file. Using `acl` provide `read + write '(rw)'` permissions to `group banner` (i.e `entity` is `banner` and `etype` is `group`).

---

# Solution

## Step 1: Navigate to the ansible directory

```bash
cd /home/thor/ansible
```

## Step 2: Create the Playbook

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Create blog.txt with ACL on app server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Create /opt/security directory
      file:
        path: /opt/security
        state: directory
        mode: '0755'

    - name: Create empty file blog.txt
      file:
        path: /opt/security/blog.txt
        state: touch

    - name: Set ACL for group tony on blog.txt
      acl:
        path: /opt/security/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present

- name: Create story.txt with ACL on app server 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Create /opt/security directory
      file:
        path: /opt/security
        state: directory
        mode: '0755'

    - name: Create empty file story.txt
      file:
        path: /opt/security/story.txt
        state: touch

    - name: Set ACL for user steve on story.txt
      acl:
        path: /opt/security/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present

- name: Create media.txt with ACL on app server 3
  hosts: stapp03
  become: yes
  tasks:
    - name: Create /opt/security directory
      file:
        path: /opt/security
        state: directory
        mode: '0755'

    - name: Create empty file media.txt
      file:
        path: /opt/security/media.txt
        state: touch

    - name: Set ACL for group banner on media.txt
      acl:
        path: /opt/security/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
EOF
```

## Step 3: Verify the Playbook

```bash
cat /home/thor/ansible/playbook.yml
```

## Step 4: Check Playbook Syntax

```bash
ansible-playbook -i /home/thor/ansible/inventory /home/thor/ansible/playbook.yml --syntax-check
```

## Step 5: Run the Playbook

```bash
ansible-playbook -i /home/thor/ansible/inventory /home/thor/ansible/playbook.yml
```

## Step 6: Verify ACL Permissions



## Explanation of the Playbook:

- ### Access Control Lists (ACLs) in Linux:

  -  Access Control Lists (ACLs) in Linux provide a more granular and flexible method for managing file and directory permissions compared to traditional Unix permissions (owner, group, others). While traditional permissions offer a basic level of control, ACLs allow administrators to define specific permissions for individual users or groups, beyond what's possible with the standard owner/group/other model.

- Ansible can be used to manage Linux ACLs through the ansible.posix.acl module. This module allows you to set, modify, and retrieve ACL information on files and directories.



### Play 1: App Server 1 (blog.txt)
```yaml
- name: Create blog.txt with ACL on app server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Set ACL for group tony on blog.txt
      acl:
        path: /opt/security/blog.txt
        entity: tony              # The name of the user or group for which to set/remove permissions.
        etype: group              # The name of the user or group for which to set/remove permissions.
        permissions: r            # The desired permissions (e.g., r, w, x, or combinations like rw).
        state: present            #  - `present`: Ensures the ACL entry exists with the specified permissions.
                                  #  - `absent`: Removes a specific ACL entry.
                                  #  - `absent_all`: Removes all ACLs from the specified path.
```
