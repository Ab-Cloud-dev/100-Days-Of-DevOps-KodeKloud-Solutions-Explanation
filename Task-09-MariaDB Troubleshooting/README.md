<img width="1516" height="845" alt="image" src="https://github.com/user-attachments/assets/4d72b251-2fff-463f-8934-5f90e80bec71" /># Task 02: MariaDb Troubleshooting

## Objective

Identifying and resloving the issues with the MariaDb





## Step-by-Step Solution



#### Step 1: Verifying the Status 


```bash
sudo systemctl status mariadb
```

the systemctl status confirms MariaDB exists right after starting, but it’s not showing the real reason (status=1 is just a generic failure).

The actual cause will almost always be in the MariaDB error log.

<img width="1516" height="845" alt="image" src="https://github.com/user-attachments/assets/3582632a-f0fc-47fa-9753-f098f9829302" />


#### Step 2: Trying to Start the Service, but unable to do so
```bash
sudo systemctl start mariadb
```

<img width="1153" height="127" alt="image" src="https://github.com/user-attachments/assets/cf4e816c-99c0-444c-96ce-8af4b70b9e70" />


#### Step 3: Checking Logs 

```bash
sudo tail -n 50 /var/log/mariadb/mariadb.log
```
<img width="1779" height="396" alt="image" src="https://github.com/user-attachments/assets/4604e0b5-b12c-445a-bc42-ad68f732208a" />

Can't create/write to file '/run/mariadb/mariadb.pid' (Errcode: 13 "Permission denied")
Can't start server: can't create PID file: Permission denied


That means MariaDB cannot write its PID file in /run/mariadb/.

#### Step 4: Give ownership to the mysql user and Starting the Service 
```bash
ls -ld /run/mariadb
#If it doesn’t exist, create it
#sudo mkdir -p /run/mariadb
sudo systemctl start mariadb
sudo chown mysql:mysql /run/mariadb
```


<img width="1126" height="359" alt="image" src="https://github.com/user-attachments/assets/9a3c99d9-fc20-42c3-897a-13a739198be5" />



This command gives MariaDB’s own user (mysql) ownership of the /run/mariadb folder so that the database server can create its necessary PID/socket files when it starts.


