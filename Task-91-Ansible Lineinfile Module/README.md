# Task-92 Managing Files Using Ansible Lineinfile Module

1. Install `httpd` web server on all app servers, and make sure its service is up and running.
2. Create a file `/var/www/html/index.html` with content:

`This is a Nautilus sample file, created using Ansible!`

1. Using `lineinfile` Ansible module add some more content in `/var/www/html/index.html` file. Below is the content:

`Welcome to Nautilus Group!`

Also make sure this new line is added at the top of the file.

1. The `/var/www/html/index.html` file's user and group `owner` should be `apache` on all app servers.
2. The `/var/www/html/index.html` file's permissions should be `0644` on all app servers.


---

# Solution:

```
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Setup Apache web server with custom content
  hosts: all
  become: yes
  tasks:
    - name: Install httpd package
      yum:
        name: httpd
        state: present

    - name: Start and enable httpd service
      service:
        name: httpd
        state: started
        enabled: yes

    - name: Create index.html with initial content
      copy:
        content: "This is a Nautilus sample file, created using Ansible!"
        dest: /var/www/html/index.html

    - name: Add new line at the top using lineinfile
      lineinfile:
        path: /var/www/html/index.html
        line: "Welcome to Nautilus Group!"
        insertbefore: BOF

    - name: Set ownership and permissions for index.html
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0644'
EOF

```
## Run the playbook

```
ansible-playbook -i /home/thor/ansible/inventory /home/thor/ansible/playbook.yml
```


## Add Line at the Top Using lineinfile

```
- name: Add new line at the top using lineinfile
  lineinfile:
    path: /var/www/html/index.html
    line: "Welcome to Nautilus Group!"
    insertbefore: BOF

```

- **lineinfile**: Module to manage lines in text files
- **line**: The line to add
- **insertbefore: BOF**: Insert before Beginning Of File (at the top)
- - `EOF` = End Of File (bottom)
- You can also use regex patterns
- **insertafter**: Insert after a specific line (alternative to insertbefore)
- **state**: `present` (default) to add, `absent` to remove

```
- name: Add line at the bottom
  lineinfile:
    path: /var/www/html/index.html
    line: "Welcome to Nautilus Group!"
    insertafter: EOF
```