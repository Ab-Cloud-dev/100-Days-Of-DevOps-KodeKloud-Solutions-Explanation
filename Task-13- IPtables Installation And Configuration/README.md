# Task 13 :

We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. Our security team has raised a concern that right now Apache’s port i.e 3004 is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:

1. Install iptables and all its dependencies on each app host.

2. Block incoming port 3004 on all apps for everyone except for LBR host.

3. Make sure the rules remain, even after system reboot.

## Step 1: Install the ansible

First, let's test the connectivity to stapp01 on port 8086:

```bash
sudo yum install ansible -y
```

And Setup the ansible configuraton file and inventory.ini

```
cat <<EOF > ansible.cfg
[defaults]
inventory = inventory.ini
host_key_checking = False
timeout = 30
gather_facts = True
retry_files_enabled = False

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
EOF
```

```
cat <<EOF > inventory.ini
[app_servers]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=Ir0nM@n ansible_ssh_common_args='-o StrictHostKeyChecking=no'  ansible_become_password=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@ ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_become_password=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_become_password=BigGr33n
EOF
```

## Step 2: Then create iptables-playbook.yml file

```
vi iptables-playbook.yml
```

```bash
---
- name: Configure iptables on App Servers
  hosts: app_servers
  become: yes
  vars:
    lbr_host_ip: "172.16.238.14"
    blocked_port: "3004"

  tasks:
    - name: Install iptables and dependencies
      yum:
        name:
          - iptables
          - iptables-services
          - iptables-utils
        state: present
      tags:
        - install

    - name: Stop and disable firewalld (if running)
      systemd:
        name: firewalld
        state: stopped
        enabled: no
      ignore_errors: yes
      tags:
        - firewall_config

    - name: Enable and start iptables service
      systemd:
        name: iptables
        state: started
        enabled: yes
      tags:
        - firewall_config

    - name: Flush existing iptables rules
      iptables:
        flush: yes
      tags:
        - rules_config

    - name: Set default INPUT policy to ACCEPT (to avoid lockout)
      iptables:
        chain: INPUT
        policy: ACCEPT
      tags:
        - rules_config

    - name: Allow loopback traffic
      iptables:
        chain: INPUT
        in_interface: lo
        jump: ACCEPT
      tags:
        - rules_config

    - name: Allow established and related connections
      iptables:
        chain: INPUT
        ctstate: ESTABLISHED,RELATED
        jump: ACCEPT
      tags:
        - rules_config

    - name: Allow SSH traffic (port 22) to prevent lockout
      iptables:
        chain: INPUT
        protocol: tcp
        destination_port: "22"
        jump: ACCEPT
      tags:
        - rules_config

    - name: Allow incoming traffic on port {{ blocked_port }} from LBR host only
      iptables:
        chain: INPUT
        protocol: tcp
        source: "{{ lbr_host_ip }}"
        destination_port: "{{ blocked_port }}"
        jump: ACCEPT
      tags:
        - rules_config

    - name: Block incoming traffic on port {{ blocked_port }} from all other sources
      iptables:
        chain: INPUT
        protocol: tcp
        destination_port: "{{ blocked_port }}"
        jump: DROP
      tags:
        - rules_config

    - name: Save iptables rules
      shell: iptables-save > /etc/sysconfig/iptables
      tags:
        - save_rules

    - name: Ensure iptables service will load rules on boot
      systemd:
        name: iptables
        enabled: yes
      tags:
        - save_rules

    - name: Display current iptables rules
      shell: iptables -L -n --line-numbers
      register: iptables_rules
      tags:
        - verify

    - name: Show iptables rules
      debug:
        var: iptables_rules.stdout_lines
      tags:
        - verify
```

## Step 3: Ping the Slaves via Ansible

```bash
ansible app_servers -m ping
```

<img width="766" height="410" alt="image" src="https://github.com/user-attachments/assets/f2330879-dcc6-4880-93c9-b79c093afa9c" />

## Step 4: Then check the iptables-playbook.yml

```bash
ansible-playbook iptables-playbook.yml --check
```

```bash
ansible-playbook iptables-playbook.yml
```
