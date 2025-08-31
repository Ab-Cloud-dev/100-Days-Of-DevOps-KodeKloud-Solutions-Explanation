# Task 08: Installing Ansible

## Objective

Installing Ansible version 4.9.0 using pip3, follow these steps

## Step-by-Step Solution


#### Step 1: Verifying Python and PiP3 installation
```bash
python3 --version
pip3 --version
```

#### Step 2: Installing Ansible
```bash
sudo pip3 install ansible==4.9.0
```

#### Step 3:  Verify the Installation
```bash
ansible --version
```
<img width="1347" height="486" alt="image" src="https://github.com/user-attachments/assets/42f9b3d6-db23-4fc8-86ca-3930ae187ffe" />

## Key-Points

- ✅ Latest version: Pip installs the latest, most up-to-date version of Ansible, giving you immediate access to new features and modules.
- ✅ User-specific installation: By default, pip can install packages into a user's home directory (~/.local/) rather than system-wide. This prevents potential conflicts with other system software. 
- ✅ MoreInfo:: https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#installing-ansible-with-pip
